use strict;
use sampleUtility;
use File::Copy;


# Initial testing
&createHelloGraphSample;

# Trivial
&createWebGroupSample;
&createWebGroupStorageSample;
&createFlightPlanSample;
createRelationsSample;
createURLTagSample;
createNDCSample;
createIGGratefulSample;
createJSNAPSample;

&createPharmGraphSample;
&createIGWikiSample;
runSocialShoppingSample;

# Special treatment
createIGLinkHunterSample;
runIGLinkHunterSampleStandard;
createPharmGraphSamplePipeline;
runIGFacebookSample;

# Long running time
createIGIMDBSample;
createIGLinkHunterSRG;

