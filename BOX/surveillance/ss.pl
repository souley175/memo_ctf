#!/usr/bin/perl -wT
#
# ==========================================================================
#
# ZoneMinder Audit Script, $Date$, $Revision$
# Copyright (C) 2001-2008 Philip Coombes
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ==========================================================================

use strict;
use bytes;

# ==========================================================================
#
# These are the elements you can edit to suit your installation
#
# ==========================================================================

use constant RECOVER_TAG => '(r)'; # Tag to append to event name when recovered
use constant RECOVER_TEXT => 'Recovered.'; # Text to append to event notes when recovered

# ==========================================================================
#
# You shouldn't need to change anything from here downwards
#
# ==========================================================================

# Include from system perl paths only
use ZoneMinder;
use DBI;
use POSIX;
use File::Find;
use Time::HiRes qw/gettimeofday/;
use Getopt::Long;
use autouse 'Pod::Usage'=>qw(pod2usage);

use constant EVENT_PATH => ($Config{ZM_DIR_EVENTS}=~m|/|)
                           ? $Config{ZM_DIR_EVENTS}
                           : ($Config{ZM_PATH_WEB}.'/'.$Config{ZM_DIR_EVENTS})
;
use constant ZM_AUDIT_PID => '/run/zm/zmaudit.pid';


$ENV{PATH}  = '/bin:/usr/bin:/usr/local/bin';
$ENV{SHELL} = '/bin/sh' if exists $ENV{SHELL};
delete @ENV{qw(IFS CDPATH ENV BASH_ENV)};

my $report = 0;
my $interactive = 0;
my $continuous = 0;
my $level = 1;
my $monitor_id = 0;
my $version;
my $force = 0;
my $server_id = undef;
my $storage_id = undef;

logInit();

GetOptions(
    continuous     =>\$continuous,
    force          =>\$force,
    interactive    =>\$interactive,
    level          =>\$level,
    'monitor_id=i' =>\$monitor_id,
    report         =>\$report,
    'server_id=i'  =>\$server_id,
    'storage_id=i' =>\$storage_id,
    version        =>\$version
    ) or pod2usage(-exitstatus => -1);

if ( $version ) {
  print( ZoneMinder::Base::ZM_VERSION . "\n");
  exit(0);
}
if ( ($report + $interactive + $continuous) > 1 ) {
  print( STDERR "Error, only one option may be specified\n" );
  pod2usage(-exitstatus => -1);
}

if ( ! exists $Config{ZM_AUDIT_MIN_AGE} ) {
  Fatal('ZM_AUDIT_MIN_AGE is not set in config.');
}

if ( -e ZM_AUDIT_PID ) {
  local $/ = undef;
  open FILE, ZM_AUDIT_PID or die "Couldn't open file: $!";
  binmode FILE;
  my $pid = <FILE>;
  close FILE;
  if ( $force ) {
    Error("zmaudit.pl appears to already be running at pid $pid. Continuing." );
  } else {
    Fatal("zmaudit.pl appears to already be running at pid $pid. If not, please delete " . 
      ZM_AUDIT_PID . " or use the --force command line option." );
  }
} # end if ZM_AUDIT_PID exists

if ( open( my $PID, '>', ZM_AUDIT_PID ) ) {
  print( $PID $$ );
  close($PID);
} else {
  Error('Can\'t open pid file at '.ZM_PID);
}

sub HupHandler {
  Info('Received HUP, reloading');
  &ZoneMinder::Logger::logHupHandler();
}
sub TermHandler {
  Info('Received TERM, exiting');
  Term();
}
sub Term {
  unlink ZM_AUDIT_PID;
  exit(0);
}
$SIG{HUP} = \&HupHandler;
$SIG{TERM} = \&TermHandler;
$SIG{INT} = \&TermHandler;

my $dbh = zmDbConnect();

$| = 1;

require ZoneMinder::Monitor;
require ZoneMinder::Storage;
require ZoneMinder::Event;

my $max_image_age = 6/24; # 6 hours
my $max_swap_age = 24/24; # 24 hours
# images now live under the event path
my $image_path = EVENT_PATH;

my $loop = 1;
my $cleaned = 0;
MAIN: while( $loop ) {

  if ( $continuous ) {
    # if we are running continuously, then just skip to the next
    # interval, otherwise we are a one off run, so wait a second and
    # retry until someone kills us.
    sleep($Config{ZM_AUDIT_CHECK_INTERVAL});
  } else {
    sleep 1;
  } # end if

  # After a long sleep, we may need to reconnect to the db
  while ( ! ( $dbh and $dbh->ping() ) ) {
    $dbh = zmDbConnect();
    if ( ! $dbh ) {
      Error('Unable to connect to database');
      if ( $continuous ) {
        # if we are running continuously, then just skip to the next
        # interval, otherwise we are a one off run, so wait a second and
        # retry until someone kills us.
        sleep($Config{ZM_AUDIT_CHECK_INTERVAL});
      } else {
        Term();
      } # end if
    } # end if
  } # end while can't connect to the db

  my @Storage_Areas;
  my @all_Storage_Areas = ZoneMinder::Storage->find();

  if ( defined $storage_id ) {
    @Storage_Areas = map { $$_{Id} == $storage_id ? $_ : () } @all_Storage_Areas;
    if ( !@Storage_Areas ) {
      Error("No Storage Area found with Id $storage_id");
      Term();
    }
    Info("Auditing Storage Area $Storage_Areas[0]{Id} $Storage_Areas[0]{Name} at $Storage_Areas[0]{Path}");
  } elsif ( $server_id ) {
    @Storage_Areas = ZoneMinder::Storage->find(ServerId => $server_id);
    if ( ! @Storage_Areas ) {
      Error('No Storage Area found with ServerId='.$server_id);
      Term();
    }
    foreach my $Storage ( @Storage_Areas ) {
      Info('Auditing ' . $Storage->Name() . ' at ' . $Storage->Path() . ' on ' . $Storage->Server()->Name() );
    }
  } else {
    @Storage_Areas = ZoneMinder::Storage->find();
    Info('Auditing All Storage Areas');
  }

  my %Monitors;
  my $db_monitors;
  my $monitorSelectSql = $monitor_id ? 'SELECT * FROM `Monitors` WHERE `Id`=?' : 'SELECT * FROM `Monitors` ORDER BY `Id`';
  my $monitorSelectSth = $dbh->prepare_cached( $monitorSelectSql )
    or Fatal( "Can't prepare '$monitorSelectSql': ".$dbh->errstr() );

  my $eventSelectSql = 'SELECT `Id`, (unix_timestamp() - unix_timestamp(`StartDateTime`)) AS Age
    FROM `Events` WHERE `MonitorId` = ?'.(@Storage_Areas ? ' AND `StorageId` IN ('.join(',',map { '?'} @Storage_Areas).')' : '' ). ' ORDER BY `Id`';
  my $eventSelectSth = $dbh->prepare_cached( $eventSelectSql )
    or Fatal( "Can't prepare '$eventSelectSql': ".$dbh->errstr() );

  $cleaned = 0;
  my $res = $monitorSelectSth->execute( $monitor_id ? $monitor_id : () )
    or Fatal( "Can't execute: $monitorSelectSql ".$monitorSelectSth->errstr() );
  while( my $monitor = $monitorSelectSth->fetchrow_hashref() ) {
    $Monitors{$$monitor{Id}} = $monitor;

    my $db_events = $db_monitors->{$monitor->{Id}} = {};
    my $res = $eventSelectSth->execute( $monitor->{Id}, map { $$_{Id} } @Storage_Areas )
      or Fatal( "Can't execute: ".$eventSelectSth->errstr() );
    while ( my $event = $eventSelectSth->fetchrow_hashref() ) {
      $db_events->{$event->{Id}} = $event->{Age};
    }
    Debug('Got '.int(keys(%$db_events))." events for monitor $monitor->{Id} using $eventSelectSql");
  } # end while monitors

  my $fs_monitors;

  foreach my $Storage ( @Storage_Areas ) {
    Debug('Checking events in ' . $Storage->Path() );
    if ( ! chdir( $Storage->Path() ) ) {
      Error( 'Unable to change dir to ' . $Storage->Path() );
      next;
    } # end if

    # Please note that this glob will take all files beginning with a digit. 
    foreach my $monitor ( glob('[0-9]*') ) {
      if ( $monitor =~ /\D/ ) {
        Debug("Weird non digit characters in $monitor");
        next;
      }
      if ( $monitor_id and ( $monitor_id != $monitor ) ) {
        Debug("Skipping monitor $monitor because we are only interested in monitor $monitor_id");
        next;
      }

      Debug("Found filesystem monitor '$monitor'");
      $fs_monitors->{$monitor} = {} if ! $fs_monitors->{$monitor};
      my $fs_events = $fs_monitors->{$monitor};

      # De-taint
      ( my $monitor_dir ) = ( $monitor =~ /^(.*)$/ );

      {
        my @day_dirs = glob("$monitor_dir/[0-9][0-9]/[0-9][0-9]/[0-9][0-9]");
        Debug(qq`Checking for Deep Events under $$Storage{Path} using glob("$monitor_dir/[0-9][0-9]/[0-9][0-9]/[0-9][0-9]") returned `. scalar @day_dirs . ' events');
        foreach my $day_dir ( @day_dirs ) {
          Debug("Checking day dir $day_dir");
          ( $day_dir ) = ( $day_dir =~ /^(.*)$/ ); # De-taint
          if ( !chdir($day_dir) ) {
            Error("Can't chdir to '$$Storage{Path}/$day_dir': $!");
            next;
          }
          if ( !opendir(DIR, '.') ) {
            Error("Can't open directory '$$Storage{Path}/$day_dir': $!");
            next;
          }
          my %event_ids_by_path;

          my @event_links = sort { $b <=> $a } grep { -l $_ } readdir(DIR);
          Debug("Have " . @event_links . ' event links');
          closedir(DIR);

          my $count = 0;
          foreach my $event_link ( @event_links ) {
            # Event links start with a period and consist of the digits of the event id. Anything else is not an event link
            my ($event_id) = $event_link =~ /^\.(\d+)$/;
            if ( !$event_id ) {
              Warning("Non-event link found $event_link in $day_dir, skipping");
              next;
            }
            #Event path is hour/minute/sec
            my $event_path = readlink($event_link);
            $event_path = '' if ! defined($event_path);
            Debug("Checking link $event_link points to: $event_path");

            if ( !($event_path and -e $event_path) ) {
              aud_print("Event link $day_dir/$event_link does not point to valid target at $event_path");
              if ( confirm() ) {
                ( $event_link ) = ( $event_link =~ /^(.*)$/ ); # De-taint
                unlink($event_link);
                $cleaned = 1;
              }
            } else {
              $event_ids_by_path{$event_path} = $event_id;

              my $Event = $fs_events->{$event_id} = ZoneMinder::Event->find_one(Id=>$event_id);
                                                        if ( ! $Event ) {
                                                                $Event = $fs_events->{$event_id} = new ZoneMinder::Event();
                                                                $$Event{Id} = $event_id;
                                                                $$Event{Path} = join('/', $Storage->Path(), $day_dir, $event_path);
                                                                $$Event{RelativePath} = join('/', $day_dir, $event_path);
                                                                $$Event{Scheme} = 'Deep';
                                                                $Event->MonitorId( $monitor_dir );
                                                                $Event->StorageId( $Storage->Id() );
                                                                $Event->DiskSpace( undef );
                                                        } else {
                                                                my $full_path = join('/', $Storage->Path(), $day_dir, $event_path);
# Check storage id
                                                                if ( $Storage->Id() and !$Event->Storage()->Id() ) {
                                                                        Info("Correcting StorageId for event $$Event{Id} from $$Event{StorageId} $$Event{Path} to $$Storage{Id} $full_path");
                                                                        $Event->save({ StorageId=>$Storage->Id() });
                                                                        $Event->Path(undef);
                                                                } else {

                                                                        if ( $Event->Path() ne $full_path ) {
                                                                                if ( ! (-e $Event->Path()) ) {
                                                                                        if ( $Event->StorageId() != $Storage->Id() ) {
                                                                                                Info("Correcting Storge Id for event $$Event{Id} from $$Event{StorageId} $$Event{Path} to $$Storage{Id} $full_path");
                                                                                                $Event->save({ StorageId=>$Storage->Id() });
                                                                                                $Event->Path(undef);
                                                                                        }
                                                                                } else {
                                                                                        Info("Not updating path to event due to it existing at both $$Event{Path} and $event_path");
                                                                                }
                                                                        } # end if change of storage id
                                                                } # end if valid storage id
                                                        } # end if event found

                                                        if ( ! $Event->SaveJPEGs() ) {
                                                                my $saveJPegs = ( $Event->has_capture_jpegs() ? 1 : 0 ) | ( $Event->has_analyse_jpegs() ? 2 : 0 );

                                                                if ( $Event->SaveJPEGs(
                                                                                ( $Event->has_capture_jpegs() ? 1 : 0 ) | ( $Event->has_analyse_jpegs() ? 2 : 0 )
                                                                                ) ) {
                                                                        Info("Updated Event $$Event{Id} SaveJPEGs to " . $Event->SaveJPEGs());
                                                                        $Event->save();
                                                                }
                                                        }

            } # event path exists
          } # end foreach event_link
            
          # Now check for events that have lost their link
          
          my @time_dirs = glob('[0-9][0-9]/[0-9][0-9]/[0-9][0-9]');
          foreach my $event_dir ( @time_dirs ) {
            Debug("Checking time dir $event_dir");
            ( $event_dir ) = ( $event_dir =~ /^(.*)$/ ); # De-taint

            my $event_id = undef;
                                                my $Event = new ZoneMinder::Event();
                                                $$Event{Path} = join('/', $Storage->Path(), $day_dir, $event_dir);

            my @contents = $Event->files();
            Debug("Have " . @contents . " files in $day_dir/$event_dir");

            my @mp4_files = grep( /^\d+\-video.mp4$/, @contents);
            foreach my $mp4_file ( @mp4_files ) {
              my ( $id ) = $mp4_file =~ /^([0-9]+)\-video\.mp4$/;
              if ( $id ) {
                $event_id = $id;
                Debug("Got event id from mp4 file $mp4_file => $event_id");
                last;
              }
            }

            if ( ! $event_id ) {
              # Look for .id file
              my @hidden_files = grep( /^\.\d+$/, @contents);
              Debug('Have ' . @hidden_files . ' hidden files');
              if ( @hidden_files ) {
                ( $event_id ) = $hidden_files[0] =~ /^.(\d+)$/;
              }
            }

            if ( $event_id and ! $fs_events->{$event_id} ) {
              $fs_events->{$event_id} = $Event;
              $$Event{Id} = $event_id;
              $$Event{RelativePath} = join('/', $day_dir, $event_dir);
              $$Event{Scheme} = 'Deep';
              $Event->MonitorId( $monitor_dir );
              $Event->StorageId( $Storage->Id() );
              $Event->DiskSpace( undef );
                                                        $Event->SaveJPEGs(
                                                                ( $Event->has_capture_jpegs() ? 1 : 0 ) | ( $Event->has_analyse_jpegs() ? 2 : 0 )
                                                                        );
              if ( ! $event_ids_by_path{$event_dir} ) {
                Warning("No event link found at ".$Event->LinkPath() ." for " . $Event->to_string());
              }
            } else {
              if ( $event_ids_by_path{$event_dir} ) {
                Debug("Have an event link, leaving dir alone.");
                next;
              }
              my ( undef, $year, $month, $day ) = split('/', $day_dir);
              $year += 2000;
              my ( $hour, $minute, $second ) = split('/', $event_dir);
              my $StartDateTime =sprintf('%.4d-%.2d-%.2d %.2d:%.2d:%.2d', $year, $month, $day, $hour, $minute, $second);
              my $Event = ZoneMinder::Event->find_one(
                MonitorId=>$monitor_dir,
                StartDateTime=>$StartDateTime,
              );
              if ( $Event ) {
                Debug("Found event matching StartDateTime on monitor $monitor_dir at $StartDateTime: " . $Event->to_string());
                next;
              }
              aud_print("Deleting event directories with no event id information at $day_dir/$event_dir");
              if ( confirm() ) {
                executeShellCommand("rm -rf $event_dir");
                $cleaned = 1;
              }
            } # end if able to find id
          } # end foreach event_dir without link
          chdir( $Storage->Path() );
        } # end foreach day dir
      }

      Debug("Checking for Medium Scheme Events under $$Storage{Path}/$monitor_dir");
      {
        my @event_dirs = glob("$monitor_dir/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/*");
        Debug('glob("'.$monitor_dir.'/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/*") returned '.(scalar @event_dirs).' entries.');
        foreach my $event_dir ( @event_dirs ) {
          if ( ! -d $event_dir ) {
            Debug("$event_dir is not a dir. Skipping");
            next;
          }
          my ( $date, $event_id ) = $event_dir =~ /^$monitor_dir\/(\d{4}\-\d{2}\-\d{2})\/(\d+)$/;
          if ( !$event_id ) {
            Debug('Unable to parse date/event_id from '.$event_dir);
            next;
          }
          my $Event = $fs_events->{$event_id} = new ZoneMinder::Event();
          $$Event{Id} = $event_id;
          $$Event{Scheme} = 'Medium';
          $$Event{RelativePath} = $event_dir;
          $Event->MonitorId( $monitor_dir );
          $Event->StorageId( $Storage->Id() );
          $Event->Path();
          $Event->age();
          Debug("Have event $$Event{Id} at $$Event{Path}");
          $Event->StartDateTime(POSIX::strftime('%Y-%m-%d %H:%M:%S', gmtime(time_of_youngest_file($Event->Path()))));
        } # end foreach event
      }

      if ( ! $$Storage{Scheme} ) {
        Error("Storage Scheme not set on $$Storage{Name}");
        if ( ! chdir($monitor_dir) ) {
          Error("Can't chdir directory '$$Storage{Path}/$monitor_dir': $!");
          next;
        }
        if ( ! opendir(DIR, '.') ) {
          Error("Can't open directory '$$Storage{Path}/$monitor_dir': $!");
          next;
        }
        my @temp_events = sort { $b <=> $a } grep { -d $_ && $_ =~ /^\d+$/ } readdir(DIR);
        closedir(DIR);
        my $count = 0;
        foreach my $event ( @temp_events ) {
          my $Event = $fs_events->{$event} = new ZoneMinder::Event();
          $$Event{Id} = $event;
          #$$Event{Path} = $event_path;
          $$Event{Scheme} = 'Shallow';
          $Event->MonitorId( $monitor_dir );
          $Event->StorageId( $Storage->Id() );
        } # end foreach event
        chdir( $Storage->Path() );
      } # if USE_DEEP_STORAGE
      Debug('Got '.int(keys(%$fs_events)).' filesystem events for monitor '.$monitor_dir);

      delete_empty_subdirs($$Storage{Path}.'/'.$monitor_dir);
    } # end foreach monitor

    if ( $cleaned ) {
      Debug('First stage cleaning done.  Restarting.');
      redo MAIN;
    }

    $cleaned = 0;
    while ( my ( $monitor_id, $fs_events ) = each(%$fs_monitors) ) {
      if ( my $db_events = $db_monitors->{$monitor_id} ) {
        if ( ! $fs_events ) {
          Debug("No fs_events for database monitor $monitor_id");
          next;
        }
        my @event_ids = keys %$fs_events;
        Debug('Have ' .scalar @event_ids . ' events for monitor '.$monitor_id);

        foreach my $fs_event_id ( sort { $a <=> $b } keys %$fs_events ) {

          my $Event = $fs_events->{$fs_event_id};

          if ( ! defined( $db_events->{$fs_event_id} ) ) {
            # Long running zmaudits can find events that were created after we loaded all db events.
            # So do a secondary lookup
            if ( ZoneMinder::Event->find_one(Id=>$fs_event_id) ) {
              Debug("$$Event{Id} found in secondary lookup.");
              next;
            }
            my $age = $Event->age();

            if ( $age and ($age > $Config{ZM_AUDIT_MIN_AGE}) ) {
              aud_print("Filesystem event $fs_event_id at $$Event{Path} does not exist in database and is $age seconds old");
              if ( confirm() ) {
                $Event->delete_files();
                $cleaned = 1;
                delete $fs_events->{$fs_event_id};
              } # end if confirm
            } # end if old enough
          } # end if ! in db events
        } # end foreach fs event
      } else {
        aud_print("Filesystem monitor '$monitor_id' in $$Storage{Path} does not exist in database");

        if ( confirm() ) {
          executeShellCommand("rm -rf $monitor_id");
          $cleaned = 1;
        }
      }
    } # end foreach monitor/filesystem events

    my $monitor_links;
    foreach my $link ( glob('*') ) {
      next if !-l $link;
      next if -e $link;

      aud_print("Filesystem monitor link '$link' does not point to valid monitor directory");
      if ( confirm() ) {
        ( $link ) = ( $link =~ /^(.*)$/ ); # De-taint
        executeShellCommand(qq`rm "$link"`);
        $cleaned = 1;
      }
    } # end foreach monitor link
  } # end foreach Storage Area

  if ( $cleaned ) {
    Debug('Events were deleted, starting again.');
    redo MAIN;
  }

  $cleaned = 0;
  my $deleteMonitorSql = 'DELETE LOW_PRIORITY FROM Monitors WHERE Id = ?';
  my $deleteMonitorSth = $dbh->prepare_cached($deleteMonitorSql)
    or Fatal("Can't prepare '$deleteMonitorSql': ".$dbh->errstr());
  my $deleteEventSql = 'DELETE LOW_PRIORITY FROM Events WHERE Id = ?';
  my $deleteEventSth = $dbh->prepare_cached( $deleteEventSql )
    or Fatal("Can't prepare '$deleteEventSql': ".$dbh->errstr());
  my $deleteFramesSql = 'DELETE LOW_PRIORITY FROM Frames WHERE EventId = ?';
  my $deleteFramesSth = $dbh->prepare_cached( $deleteFramesSql )
    or Fatal("Can't prepare '$deleteFramesSql': ".$dbh->errstr());
  my $deleteStatsSql = 'DELETE LOW_PRIORITY FROM Stats WHERE EventId = ?';
  my $deleteStatsSth = $dbh->prepare_cached( $deleteStatsSql )
    or Fatal("Can't prepare '$deleteStatsSql': ".$dbh->errstr());

  # Foreach database monitor and it's list of events.
  while ( my ( $db_monitor, $db_events ) = each(%$db_monitors) ) {
    Debug("Checking db events for monitor $db_monitor");
    if ( ! $db_events ) {
      Debug("Skipping db events for $db_monitor because there are none");
      next;
    }

    # If we found the monitor in the file system
    my $fs_events = $fs_monitors->{$db_monitor};

EVENT: while ( my ( $db_event, $age ) = each( %$db_events ) ) {
      if ( ! ($fs_events and defined( $fs_events->{$db_event} ) ) ) {
        Debug("Don't have an fs event for $db_event");
        my $Event = ZoneMinder::Event->find_one( Id=>$db_event );
        if ( ! $Event ) {
          Debug("Event $db_event is no longer in db.  Filter probably deleted it while we were auditing.");
          next;
        }
        Debug("Event $db_event is not in fs. Should have been at ".$Event->Path());
        # Check for existence in other Storage Areas
        foreach my $Storage ( @all_Storage_Areas ) {
          next if $$Storage{Id} == $$Event{StorageId};

          my $path = $Storage->Path().'/'.$Event->RelativePath();
          if ( -e $path ) {
            Info("Event $$Event{Id} found at $path instead of $$Event{Path}");
            if ( confirm('update', 'updating') ) {
              $Event->save({StorageId=>$$Storage{Id}});
              next EVENT;
            }
          } else {
            Debug("$$Event{Id} Not found at $path");
          }
        } # end foreach Storage
        if ( $Event->Archived() ) {
          Warning("Event $$Event{Id} is Archived. Taking no further action on it.");
          next;
        }
        if ( !$Event->StartDateTime() ) {
          aud_print("Event $$Event{Id} has no start time.");
          if ( confirm() ) {
            $Event->delete();
            $cleaned = 1;
          }
          next;
        } 
        if ( ! $Event->EndDateTime() ) {
          if ( $age > $Config{ZM_AUDIT_MIN_AGE} ) {
            aud_print("Event $$Event{Id} has no end time and is $age seconds old. Deleting it.");
            if ( confirm() ) {
              $Event->delete();
              $cleaned = 1;
            }
            next;
          }
        }
        if ( $Event->check_for_in_filesystem() ) {
          Debug("Database event $$Event{Id} apparently exists at " . $Event->Path());
        } else {
          if ( $age > $Config{ZM_AUDIT_MIN_AGE} ) {
            aud_print("Database event '$db_monitor/$db_event' does not exist at " . $Event->Path().' in filesystem, deleting');
            if ( confirm() ) {
              $Event->delete();
              $cleaned = 1;
            }
          } else {
            aud_print("Database event '".$Event->Path()." monitor:$db_monitor event:$db_event' does not exist in filesystem but too young to delete age: $age > MIN $Config{ZM_AUDIT_MIN_AGE}.");
          }
        } # end if exists in filesystem
      } else {
        Debug("Found fs event for id $db_event, $age seconds old at " . $$fs_events{$db_event}->Path());
        my $Event = ZoneMinder::Event->find_one( Id=>$db_event );
        if ( $Event and ! $Event->check_for_in_filesystem() ) {
          Warning('Not found at ' . $Event->Path() . ' was found at ' . $$fs_events{$db_event}->Path());
          Warning($Event->to_string());
          Warning($$fs_events{$db_event}->to_string());
          $$Event{Scheme} = '' if ! defined $$Event{Scheme};
          if ( $$fs_events{$db_event}->Scheme() ne $Event->Scheme() ) {
            Info("Updating scheme on event $$Event{Id} from $$Event{Scheme} to $$fs_events{$db_event}{Scheme}");
            $Event->Scheme($$fs_events{$db_event}->Scheme());
          } 
          if ( $$fs_events{$db_event}->StorageId() != $Event->StorageId() ) {
            Info("Updating storage area on event $$Event{Id} from $$Event{StorageId} to $$fs_events{$db_event}{StorageId}");
            $Event->StorageId($$fs_events{$db_event}->StorageId());
          }
          if ( ! $Event->StartDateTime() ) {
            Info("Updating StartDateTime on event $$Event{Id} from $$Event{StartDateTime} to $$fs_events{$db_event}{StartDateTime}");
            $Event->StartDateTime($$fs_events{$db_event}->StartDateTime());
          }

          $Event->save();
        } # end if Event exists in db and not in filesystem
      } # end if ! in fs_events
    } # foreach db_event
  } # end foreach db_monitor
  if ( $cleaned ) {
    Debug('Have done some cleaning, restarting.');
    redo MAIN;
  }

if ( $level > 1 ) {
# Remove orphaned events (with no monitor)
# Shouldn't be possible anymore with FOREIGN KEYS in place
  $cleaned = 0;
  Debug("Checking for Orphaned Events");
  my $selectOrphanedEventsSql = 'SELECT `Events`.`Id`, `Events`.`Name`
    FROM `Events` LEFT JOIN `Monitors` ON (`Events`.`MonitorId` = `Monitors`.`Id`)
    WHERE isnull(`Monitors`.`Id`)';
  my $selectOrphanedEventsSth = $dbh->prepare_cached( $selectOrphanedEventsSql )
    or Error("Can't prepare '$selectOrphanedEventsSql': ".$dbh->errstr());
  $res = $selectOrphanedEventsSth->execute()
    or Error("Can't execute: ".$selectOrphanedEventsSth->errstr());

  while( my $event = $selectOrphanedEventsSth->fetchrow_hashref() ) {
    aud_print("Found orphaned event with no monitor '$event->{Id}'");
    if ( confirm() ) {
      if ( $res = $deleteEventSth->execute($event->{Id}) ) {
        $cleaned = 1;
      } else {
        Error("Can't execute: ".$deleteEventSth->errstr());
      }
    }
  }
  redo MAIN if $cleaned;
} # end if level > 1

# Remove empty events (with no frames)
  $cleaned = 0;
  Debug("Checking for Events with no Frames");
  my $selectEmptyEventsSql = 'SELECT `E`.`Id` AS `Id`, `E`.`StartDateTime`, `F`.`EventId` FROM `Events` AS E LEFT JOIN `Frames` AS F ON (`E`.`Id` = `F`.`EventId`)
    WHERE isnull(`F`.`EventId`) AND now() - interval '.$Config{ZM_AUDIT_MIN_AGE}.' second > `E`.`StartDateTime`';
  if ( my $selectEmptyEventsSth = $dbh->prepare_cached( $selectEmptyEventsSql ) ) {
    if ( $res = $selectEmptyEventsSth->execute() ) {
      while( my $event = $selectEmptyEventsSth->fetchrow_hashref() ) {
        aud_print("Found empty event with no frame records '$event->{Id}' at $$event{StartDateTime}");
        if ( confirm() ) {
          if ( $res = $deleteEventSth->execute($event->{Id}) ) {
            $cleaned = 1;
          } else {
            Error("Can't execute: ".$deleteEventSth->errstr());
          }
        }
      } # end foreach row
    } else {
      Error("Can't execute: ".$selectEmptyEventsSth->errstr());
    }
  } else {
    Error("Can't prepare '$selectEmptyEventsSql': ".$dbh->errstr());
  }
  redo MAIN if $cleaned;

# Remove orphaned frame records
  $cleaned = 0;
  Debug('Checking for Orphaned Frames');
  my $selectOrphanedFramesSql = 'SELECT DISTINCT `EventId` FROM `Frames`
    WHERE (SELECT COUNT(*) FROM `Events` WHERE `Events`.`Id`=`EventId`)=0';
  my $selectOrphanedFramesSth = $dbh->prepare_cached( $selectOrphanedFramesSql )
    or Fatal("Can't prepare '$selectOrphanedFramesSql': ".$dbh->errstr());
  $res = $selectOrphanedFramesSth->execute()
    or Fatal("Can't execute: ".$selectOrphanedFramesSth->errstr());
  while( my $frame = $selectOrphanedFramesSth->fetchrow_hashref() ) {
    aud_print("Found orphaned frame records for event '$frame->{EventId}'");
    if ( confirm() ) {
      $res = $deleteFramesSth->execute($frame->{EventId})
        or Fatal("Can't execute: ".$deleteFramesSth->errstr());
      $cleaned = 1;
    }
  }
  redo MAIN if $cleaned;

if ( $level > 1 ) {
# Remove orphaned stats records
  $cleaned = 0;
  Debug('Checking for Orphaned Stats');
  my $selectOrphanedStatsSql = 'SELECT DISTINCT `EventId` FROM `Stats`
    WHERE `EventId` NOT IN (SELECT `Id` FROM `Events`)';
  my $selectOrphanedStatsSth = $dbh->prepare_cached( $selectOrphanedStatsSql )
    or Fatal("Can't prepare '$selectOrphanedStatsSql': ".$dbh->errstr());
  $res = $selectOrphanedStatsSth->execute()
    or Fatal("Can't execute: ".$selectOrphanedStatsSth->errstr());
  while( my $stat = $selectOrphanedStatsSth->fetchrow_hashref() ) {
    aud_print("Found orphaned statistic records for event '$stat->{EventId}'");
    if ( confirm() ) {
      $res = $deleteStatsSth->execute( $stat->{EventId} )
        or Fatal("Can't execute: ".$deleteStatsSth->errstr());
      $cleaned = 1;
    }
  }
  redo MAIN if ( $cleaned );
}

# New audit to close any events that were left open for longer than MIN_AGE seconds
  my $selectUnclosedEventsSql =
#"SELECT E.Id, ANY_VALUE(E.MonitorId),
#
#max(F.TimeStamp) as EndTime,
#unix_timestamp(max(F.TimeStamp)) - unix_timestamp(E.StartDateTime) as Length,
#max(F.FrameId) as Frames,
#count(if(F.Score>0,1,NULL)) as AlarmFrames,
#sum(F.Score) as TotScore,
#max(F.Score) as MaxScore
#FROM Events as E
#INNER JOIN Frames as F on E.Id = F.EventId
#WHERE isnull(E.Frames) or isnull(E.EndTime)
#GROUP BY E.Id HAVING EndTime < (now() - interval ".$Config{ZM_AUDIT_MIN_AGE}.' second)'
#;
    'SELECT *, unix_timestamp(`StartDateTime`) AS `TimeStamp` FROM `Events` WHERE `EndDateTime` IS NULL AND `StartDateTime` < (now() - interval '.$Config{ZM_AUDIT_MIN_AGE}.' second)'.($monitor_id?' AND MonitorId=?':'');

  my $selectFrameDataSql = '
SELECT
  max(`TimeStamp`) AS `EndDateTime`,
  unix_timestamp(max(`TimeStamp`)) AS `EndTimeStamp`,
  max(`FrameId`) AS `Frames`,
  count(if(`Score`>0,1,NULL)) AS `AlarmFrames`,
  sum(`Score`) AS `TotScore`,
  max(`Score`) AS `MaxScore`
FROM `Frames` WHERE `EventId`=?';
  my $selectFrameDataSth = $dbh->prepare_cached($selectFrameDataSql)
    or Fatal("Can't prepare '$selectFrameDataSql': ".$dbh->errstr());

  my $selectUnclosedEventsSth = $dbh->prepare_cached($selectUnclosedEventsSql)
    or Fatal("Can't prepare '$selectUnclosedEventsSql': ".$dbh->errstr());
  my $updateUnclosedEventsSql =
    "UPDATE low_priority `Events`
    SET `Name` = ?,
        `EndDateTime` = ?,
        `Length` = ?,
        `Frames` = ?,
        `AlarmFrames` = ?,
        `TotScore` = ?,
        `AvgScore` = ?,
        `MaxScore` = ?,
        `Notes` = concat_ws( ' ', `Notes`, ? )
          WHERE `Id` = ?"
          ;
  my $updateUnclosedEventsSth = $dbh->prepare_cached( $updateUnclosedEventsSql )
    or Fatal("Can't prepare '$updateUnclosedEventsSql': ".$dbh->errstr());
  $res = $selectUnclosedEventsSth->execute($monitor_id?$monitor_id:())
    or Fatal("Can't execute: ".$selectUnclosedEventsSth->errstr());
  while( my $event = $selectUnclosedEventsSth->fetchrow_hashref() ) {
    aud_print("Found open event '$event->{Id}' on Monitor $event->{MonitorId} at $$event{StartDateTime}");
    if ( confirm('close', 'closing') ) {
      if ( ! ( $res = $selectFrameDataSth->execute($event->{Id}) ) ) {
        Error("Can't execute: $selectFrameDataSql:".$selectFrameDataSth->errstr());
        next;
      }
      my $frame = $selectFrameDataSth->fetchrow_hashref();
      if ( $frame ) {
        $res = $updateUnclosedEventsSth->execute(
           sprintf('%s%d%s',
             $Monitors{$event->{MonitorId}}->{EventPrefix},
             $event->{Id},
             RECOVER_TAG
             ),
           $frame->{EndDateTime},
           $frame->{EndTimeStamp} - $event->{TimeStamp},
           $frame->{Frames},
           $frame->{AlarmFrames},
           $frame->{TotScore},
           $frame->{AlarmFrames}
           ? int($frame->{TotScore} / $frame->{AlarmFrames})
           : 0
           ,
           $frame->{MaxScore},
           RECOVER_TEXT,
           $event->{Id}
          ) or Error('Can\'t execute: '.$updateUnclosedEventsSth->errstr());
      } else {
        Error('SHOULD DELETE');
      } # end if has frame data
    }
  } # end while unclosed event
  Debug('Done closing open events.');

# Now delete any old image files
  if ( my @old_files = grep { -M > $max_image_age } <$image_path/*.{jpg,gif,wbmp}> ) {
    aud_print('Deleting '.int(@old_files)." old images\n");
    my $untainted_old_files = join( ';', @old_files );
    ( $untainted_old_files ) = ( $untainted_old_files =~ /^(.*)$/ );
    unlink( split( /;/, $untainted_old_files ) );
  }

  # Now delete any old swap files
  ( my $swap_image_root ) = ( $Config{ZM_PATH_SWAP} =~ /^(.*)$/ ); # De-taint
  File::Find::find( { wanted=>\&deleteSwapImage, untaint=>1 }, $swap_image_root );

  # Prune the Logs table if required
  if ( $Config{ZM_LOG_DATABASE_LIMIT} ) {
    if ( $Config{ZM_LOG_DATABASE_LIMIT} =~ /^\d+$/ ) {
      # Number of rows
      my $selectLogRowCountSql = 'SELECT count(*) AS `Rows` FROM `Logs`';
      my $selectLogRowCountSth = $dbh->prepare_cached( $selectLogRowCountSql )
        or Fatal("Can't prepare '$selectLogRowCountSql': ".$dbh->errstr());
      $res = $selectLogRowCountSth->execute()
        or Fatal("Can't execute: ".$selectLogRowCountSth->errstr());
      my $row = $selectLogRowCountSth->fetchrow_hashref();
      my $logRows = $row->{Rows};
      if ( $logRows > $Config{ZM_LOG_DATABASE_LIMIT} ) {
        my $deleteLogByRowsSql = 'DELETE low_priority FROM `Logs` ORDER BY `TimeKey` ASC LIMIT ?';
        my $deleteLogByRowsSth = $dbh->prepare_cached( $deleteLogByRowsSql )
          or Fatal("Can't prepare '$deleteLogByRowsSql': ".$dbh->errstr());
        $res = $deleteLogByRowsSth->execute( $logRows - $Config{ZM_LOG_DATABASE_LIMIT} )
          or Fatal("Can't execute: ".$deleteLogByRowsSth->errstr());
        if ( $deleteLogByRowsSth->rows() ) {
          aud_print('Deleted '.$deleteLogByRowsSth->rows() ." log table entries by count\n");
        }
      }
    } else {
      # Time of record
      
      # 7 days is invalid.  We need to remove the s
      if ( $Config{ZM_LOG_DATABASE_LIMIT} =~ /^(.*)s$/ ) {
        $Config{ZM_LOG_DATABASE_LIMIT} = $1;
      }
      my $deleted_rows;
      do {
        my $deleteLogByTimeSql =
        'DELETE FROM `Logs`
        WHERE `TimeKey` < unix_timestamp(now() - interval '.$Config{ZM_LOG_DATABASE_LIMIT}.') LIMIT 10';
        my $deleteLogByTimeSth = $dbh->prepare_cached( $deleteLogByTimeSql )
          or Fatal("Can't prepare '$deleteLogByTimeSql': ".$dbh->errstr());
        $res = $deleteLogByTimeSth->execute()
          or Fatal("Can't execute: ".$deleteLogByTimeSth->errstr());
        $deleted_rows = $deleteLogByTimeSth->rows();
        aud_print("Deleted $deleted_rows log table entries by time\n");
      } while ( $deleted_rows );
    }
  } # end if ZM_LOG_DATABASE_LIMIT
  $loop = $continuous;

  my $eventcounts_sql = '
  UPDATE `Event_Summaries` SET
  `TotalEvents`=(SELECT COUNT(`Id`) FROM `Events` WHERE `MonitorId`=`Event_Summaries`.`MonitorId`),
  `TotalEventDiskSpace`=(SELECT SUM(`DiskSpace`) FROM `Events` WHERE `MonitorId`=`Event_Summaries`.`MonitorId` AND `DiskSpace` IS NOT NULL),
  `ArchivedEvents`=(SELECT COUNT(`Id`) FROM `Events` WHERE `MonitorId`=`Event_Summaries`.`MonitorId` AND `Archived`=1),
  `ArchivedEventDiskSpace`=(SELECT SUM(`DiskSpace`) FROM `Events` WHERE `MonitorId`=`Event_Summaries`.`MonitorId` AND `Archived`=1 AND `DiskSpace` IS NOT NULL)
  ';

  my $eventcounts_sth = $dbh->prepare_cached( $eventcounts_sql );
  $eventcounts_sth->execute();
  $eventcounts_sth->finish();

  my $eventcounts_hour_sql = '
  UPDATE `Event_Summaries` INNER JOIN (
  SELECT  `MonitorId`, COUNT(*) AS `HourEvents`, SUM(COALESCE(`DiskSpace`,0)) AS `HourEventDiskSpace`
  FROM `Events_Hour` GROUP BY `MonitorId`
  ) AS `E` ON `E`.`MonitorId`=`Event_Summaries`.`MonitorId` SET
  `Event_Summaries`.`HourEvents` = `E`.`HourEvents`,
  `Event_Summaries`.`HourEventDiskSpace` = `E`.`HourEventDiskSpace`
  ';


  my $eventcounts_day_sql = '
  UPDATE `Event_Summaries` INNER JOIN (
  SELECT  `MonitorId`, COUNT(*) AS `DayEvents`, SUM(COALESCE(`DiskSpace`,0)) AS `DayEventDiskSpace`
  FROM `Events_Day` GROUP BY `MonitorId`
  ) AS `E` ON `E`.`MonitorId`=`Event_Summaries`.`MonitorId` SET
  `Event_Summaries`.`DayEvents` = `E`.`DayEvents`,
  `Event_Summaries`.`DayEventDiskSpace` = `E`.`DayEventDiskSpace`
  ';

  my $eventcounts_week_sql = '
  UPDATE `Event_Summaries` INNER JOIN (
  SELECT  `MonitorId`, COUNT(*) AS `WeekEvents`, SUM(COALESCE(`DiskSpace`,0)) AS `WeekEventDiskSpace`
  FROM `Events_Week` GROUP BY `MonitorId`
  ) AS `E` ON `E`.`MonitorId`=`Event_Summaries`.`MonitorId` SET
  `Event_Summaries`.`WeekEvents` = `E`.`WeekEvents`,
  `Event_Summaries`.`WeekEventDiskSpace` = `E`.`WeekEventDiskSpace`
  ';

  my $eventcounts_month_sql = '
  UPDATE `Event_Summaries` INNER JOIN (
  SELECT  `MonitorId`, COUNT(*) AS `MonthEvents`, SUM(COALESCE(`DiskSpace`,0)) AS `MonthEventDiskSpace`
  FROM `Events_Month` GROUP BY `MonitorId`
  ) AS `E` ON `E`.`MonitorId`=`Event_Summaries`.`MonitorId` SET
  `Event_Summaries`.`MonthEvents` = `E`.`MonthEvents`,
  `Event_Summaries`.`MonthEventDiskSpace` = `E`.`MonthEventDiskSpace`
  ';
  my $eventcounts_hour_sth = $dbh->prepare_cached($eventcounts_hour_sql);
  my $eventcounts_day_sth = $dbh->prepare_cached($eventcounts_day_sql);
  my $eventcounts_week_sth = $dbh->prepare_cached($eventcounts_week_sql);
  my $eventcounts_month_sth = $dbh->prepare_cached($eventcounts_month_sql);
  $eventcounts_hour_sth->execute() or Error("Can't execute: ".$eventcounts_sth->errstr());
  $eventcounts_day_sth->execute() or Error("Can't execute: ".$eventcounts_sth->errstr());
  $eventcounts_week_sth->execute() or Error("Can't execute: ".$eventcounts_sth->errstr());
  $eventcounts_month_sth->execute() or Error("Can't execute: ".$eventcounts_sth->errstr());

  my $storage_diskspace_sth = $dbh->prepare_cached('UPDATE Storage SET DiskSpace=(SELECT SUM(DiskSpace) FROM Events WHERE StorageId=Storage.Id)');
  $storage_diskspace_sth->execute() or Error("Can't execute: ".$storage_diskspace_sth->errstr());

  sleep($Config{ZM_AUDIT_CHECK_INTERVAL}) if $continuous;
};

Term();

sub aud_print {
  my $string = shift;
  if ( !$continuous ) {
    print($string);
  } else {
    Info($string);
  }
}

sub confirm {
  my $prompt = shift || 'delete';
  my $action = shift || 'deleting';

  my $yesno = 0;
  if ( $report ) {
    print("\n");
  } elsif ( $interactive ) {
    print(", $prompt Y/n/q: ");
    my $char = <>;
    chomp($char);
    if ( $char eq 'q' ) {
      exit(0);
    }
    if ( !$char ) {
      $char = 'y';
    }
    $yesno = ( $char =~ /[yY]/ );
  } else {
    if ( !$continuous ) {
      print(", $action\n");
    } else {
      Info($action);
    }
    $yesno = 1;
  }
  return $yesno;
}

sub deleteSwapImage {
  my $file = $_;

  return if $file =~ /^./;

  if ( $file !~ /^zmswap-/ ) {
    Error( "Trying to delete SwapImage that isnt a swap image $file" );
    return;
  }

# Ignore directories
  if ( -d $file ) {
    Error( "Trying to delete a directory instead of a swap image $file" );
    return;
  }

  if ( -M $file > $max_swap_age ) {
    ( $file ) = ( $file =~ /^(.*)$/ );
  
    Debug( "Deleting $file" );
    unlink( $file );
  }
}

# Deletes empty sub directories of the given path.
# Does not delete the path if empty. Is not meant to be recursive.
# Assumes absolute path
sub delete_empty_subdirs {
  my $DIR;
  if ( !opendir($DIR, $_[0]) ) {
    Error("delete_empty_subdirs: Can't open directory '/$_[0]': $!" );
    return;
  }
  my @contents = map { ( $_ eq '.' or $_ eq '..' ) ? () : $_ } readdir( $DIR );
  Debug("delete_empty_subdirectories $_[0] has " . @contents .' entries:' . ( @contents < 2 ? join(',',@contents) : '' ));
  my @dirs = map { -d $_[0].'/'.$_ ? $_ : () } @contents;
  Debug("Have " . @dirs . " dirs");
  foreach ( @dirs ) {
    delete_empty_directories( $_[0].'/'.$_ );
  }
  closedir($DIR);
}

# Assumes absolute path
sub delete_empty_directories {
  my $DIR;
  if ( !opendir($DIR, $_[0]) ) {
    Error("delete_empty_directories: Can't open directory '/$_[0]': $!" );
    return;
  }
  my @contents = map { ( $_ eq '.' or $_ eq '..' ) ? () : $_ } readdir($DIR);
  #Debug("delete_empty_directories $_[0] has " . @contents .' entries:' . ( @contents <= 2 ? join(',',@contents) : '' ));
  my @dirs = map { -d $_[0].'/'.$_ ? $_ : () } @contents;
  if ( @dirs ) {
    Debug('Have ' . @dirs . " dirs in $_[0]");
    foreach ( @dirs ) {
      delete_empty_directories($_[0].'/'.$_);
    }
#Reload, since we may now be empty
    rewinddir $DIR;
    @contents = map { ($_ eq '.' or $_ eq '..') ? () : $_ } readdir($DIR);
  }
  closedir($DIR);
  if ( ! @contents ) {
    ( my $dir ) = ( $_[0] =~ /^(.*)$/ );
    Debug("Unlinking $dir because it's empty");
    if ( ! rmdir $dir ) {
      Error("Unable to unlink $dir: $!");
    }
  } 
} # end sub delete_empty_directories

# The idea is that the youngest file in the event directory gives us the event starttime
sub time_of_youngest_file {
  my $dir = shift;

  if ( ! opendir(DIR, $dir) ) {
    Error("Can't open directory '$dir': $!");
    return;
  }
  my $youngest = (stat($dir))[9];
  Debug("stat of dir $dir is $youngest");
  foreach my $file ( readdir( DIR ) ) {
    next if $file =~ /^\./;
    $_ = (stat($dir))[9];
    if ($_ and ($_ < $youngest)) {
      $youngest = $_;
      Debug("Found younger file $file at $youngest");
    }
  }
  return $youngest;
} # end sub time_of_youngest_file

1;
__END__

=head1 NAME

zmaudit.pl - ZoneMinder event file system and database consistency checker

=head1 SYNOPSIS

 zmaudit.pl [-r,-report|-i,-interactive]

=head1 DESCRIPTION

This script checks for consistency between the event filesystem and
the database. If events are found in one and not the other they are
deleted (optionally). Additionally any monitor event directories that
do not correspond to a database monitor are similarly disposed of.
However monitors in the database that don't have a directory are left
alone as this is valid if they are newly created and have no events
yet.

=head1 OPTIONS

 -c, --continuous           - Run continuously
 -f, --force                - Run even if pid file exists
 -i, --interactive          - Ask before applying any changes
 -m, --monitor_id           - Only consider the given monitor
 -r, --report               - Just report don't actually do anything
 -s, --storage_id           - Specify a storage area to audit instead of all
 -v, --version              - Print the installed version of ZoneMinder
