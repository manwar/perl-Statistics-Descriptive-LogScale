#!/usr/bin/env perl

use strict;
use warnings FATAL => qw(all);
use Test::More;

use Statistics::Descriptive::LogScale;
my $stat = Statistics::Descriptive::LogScale->new;

# methods that return 0 on emptyset
my @ok_empty = qw(count sum sumsq variance);
# methods which won't work on empty set
my @require0 = qw(min max sample_range mean std_dev median
	harmonic_mean geometric_mean);
# methods that won't work on just one data point
my @require1 = qw(kurtosis skewness);

# self-test
my @missing = grep { !$stat->can($_) } @ok_empty, @require0, @require1;
die "Missing methods listed in test, aborting: @missing"
	if @missing;

foreach my $method ( @ok_empty ) {
	# Try each method. No warnings allowed!
	my $result = eval {
		local $SIG{__WARN__} = sub { die shift };
		$stat->$method;
	};
	is ($@, '', "$method: no exception");
	is ($result, 0, "$method: result is 0");
};

foreach my $method ( @require0, @require1 ) {
	# Try each method. No warnings allowed!
	my $result = eval {
		local $SIG{__WARN__} = sub { die shift };
		$stat->$method;
	};
	is ($@, '', "$method: no exception");
	is ($result, undef, "$method: result undefined");
};


$stat->add_data(1);
foreach my $method ( @require1 ) {
	# Try each method. No warnings allowed!
	my $result = eval {
		local $SIG{__WARN__} = sub { die shift };
		$stat->$method;
	};
	is ($@, '', "$method: no exception");
	is ($result, undef, "$method: result undefined");
};

done_testing;