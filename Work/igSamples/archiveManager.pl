use strict;
use Utility;
use File::Copy;

# We skipped generating IGFacebookSample, JSNAPMongoDB, and IGLinkHunterSample
my @samples = qw/ FlightPlanSample
HelloGraphSample
IGFacebookSample
IGGratefulSample
IGIMDBSample
IGLinkHunterSample
IGWikiSample
JSNAPMongoDB
JSNAPSample
NDCSample
PharmGraphSample
PharmGraphSamplePipeline
RelationsSample
URLTagSample
WebGroupSample
WebGroupStorageSample/;


###########################################################
###########################################################

# # Create sample folders for each platform
# my $dir = "Win64";
# chdir "$dir" or die "Cannot chdir to $dir: $!";
# foreach my $sample (@samples)
# {
	# mkdir $sample, 0755 or warn "Cannot create directory: $!";
	# print "Folder $sample created\n";
# }

# die "Here";

###########################################################
###########################################################


# Initial testing
&createHelloGraphSample;

# Trivial
&createWebGroupSample;
&createWebGroupStorageSample;
&createFlightPlanSample;
createRelationsSample;
createNDCSample;
createIGGratefulSample;
createURLTagSample;
createJSNAPSample;
&createPharmGraphSample;
&createIGWikiSample;
 
# Long running time
createIGIMDBSample;
createIGLinkHunterSample;

# Special treatment
createPharmGraphSamplePipeline;
