@RestResource(urlMapping='/Positions/*')
global with sharing class PositionsRestResource {

    @HttpPost
    global static List<Position__c> getPositions(String status, Integer positionsPerPage, Integer currentPage) {
        try {
            return PositionsHelper.getPositions(status, positionsPerPage, currentPage);
        } catch(Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new CalloutException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @HttpGet
    global static Integer getPositionsCount () {
        try {
            RestRequest request = RestContext.request;
            String status = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
            return PositionsHelper.getPositionsCount(status);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new CalloutException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @HttpPatch
    global static void updatePositions(Position__c[] positions){
        try {
            PositionsHelper.updatePositions(positions);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new CalloutException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}