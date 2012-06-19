# --
# Kernel/Output/HTML/ToolBarTicketEscalated.pm
# Copyright (C) 2012 Perl-Services.de, http://perl-services.de/
# --
# $Id: ToolBarTicketEscalated.pm,v 1.7 2011/01/21 18:01:40 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketEscalated;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get user lock data
    my $Count = $Self->{TicketObject}->TicketSearch(
        Result                           => 'COUNT',
        TicketEscalationTimeOlderMinutes => 0,
        OwnerIDs                         => [ $Self->{UserID} ],
        UserID                           => 1,
        Permission                       => 'ro',
    );

    my $Class    = $Param{Config}->{CssClass};
    my $Text     = $Self->{LayoutObject}->{LanguageObject}->Get('Escalated Tickets Total');
    my $URL      = $Self->{LayoutObject}->{Baselink};
    my $Priority = $Param{Config}->{Priority};
    
    my %Return;
    if ($Count) {
        $Return{$Priority} = {
            Block       => 'ToolBarItem',
            Count       => $Count,
            Description => $Text,
            Class       => $Class,
            Link        => $URL . 'Action=AgentTicketEscalationView',
            AccessKey   => 'e',
        };
    }

    return %Return;
}

1;
