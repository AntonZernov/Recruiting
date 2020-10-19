public with sharing class MetadataDeployCallback implements Metadata.DeployCallback {
    public static String METADATA_DEPLOYED = 'Settings Deployment Succeeded!';
    public static String METADATA_DEPLOY_FAILED = 'Settings Deployment Failed!';

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(METADATA_DEPLOYED);
        } else {
	        System.debug(METADATA_DEPLOY_FAILED);
	        System.debug(result.errorMessage);
        }
    }
}