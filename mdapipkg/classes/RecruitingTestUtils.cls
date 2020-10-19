@isTest
public class RecruitingTestUtils {
    public static final String OPENED = 'Opened';
    public static final String CLOSED = 'Closed';
    public static final String CANDIDATE_OBJECT = 'testtest123__Candidate__c';
    public static final String NAME_FIELD = 'Name';
    public static final String TEST_USER_NAME = 'standarduser';
    public static final String TEST_ORG = '@testorg.com';
    public static final String STANDART_EMPLOYEE_PROFILE = 'Standart Employee';
    public static final String TEST_ALIAS = 'standt';
    public static final String UTF_8 = 'UTF-8';
    public static final String EN_LANGUAGE = 'en_US';
    public static final String TEST_TIME_ZONE = 'America/Los_Angeles';
    public static final String BIRTH_DATE_FIELD = 'testtest123__Birth_Date__c';
    public static final String FIRST_STAGE = '1st New stage';
    public static final String TEST_API_NAME = 'Test';
    public static final String TEST_TEXT_FIELD = 'Test';
    public static final String CLOSE_OLD_POSITIONS_TEST = 'Test job';
    public static final String EXCEPTION_NORMAL = 
                'Deployment metadata via test is impossible, exception is normal behavior';
    public static final Integer DAYS_EXPIRED = 91;
    public static final String TEST_EMAIL = 'test@test.com';
    public static final String TEST_URL = 'test.com';
    public static final String TEST_PHONE_NUMBER = '5555555';
    public static final String TEST_LOCATION = 'London';
    public static final String TEST_SKILL = 'SQL';
    public static final String TEST_ORDER = 'Name ASC';
    public static final String TEST_SHORT_SEARCH_STRING = 'A';
    public static final String TEST_LONG_SEARCH_STRING = 'te';
    public static final String TEST_SEARCH_MODE = 'ALL FIELDS';
    public static final String ERROR_STATUS = 'error status';
    public static final String UNEDITABLE_FIELD = 'LastModifiedById';
    public static final String ILLEGAL_ARGUMENT_EXCEPTION = 'System.IllegalArgumentException';
    
    public static void createOpenedPositions(Integer numberOfPositions) {
        List<testtest123__Position__c> posOpenedList = new List<testtest123__Position__c>();
        for (Integer i = 0; i < numberOfPositions; i++) {
            posOpenedList.add(getOpenedPosition());
        }
        insert posOpenedList;
    }
    public static void createOpenedPositions(Integer numberOfPositions, Date dateOpened) {
        List<testtest123__Position__c> posOpenedList = new List<testtest123__Position__c>();
        for (Integer i = 0; i < numberOfPositions; i++) {
            posOpenedList.add(getOpenedPosition());
        }
        for (testtest123__Position__c position : posOpenedList) {
            position.Date_Opened__c = dateOpened;
        }
        insert posOpenedList;
    }
    public static void createClosedPositions(Integer numberOfPositions) {
        List<testtest123__Position__c> posClosedList = new List<testtest123__Position__c>();
        for (Integer i = 0; i < numberOfPositions; i++) {
            posClosedList.add(getClosedPosition());
        }
        insert posClosedList;
    }
    public static void createJobApps(Integer numberOfJobApps) {
        createOpenedPositions(numberOfJobApps);
        List<testtest123__Candidate__c> candidate = new List<testtest123__Candidate__c>();
        List<testtest123__Position__c> positionsList = new List<testtest123__Position__c>();
        List<testtest123__JobApp__c> jobAppsList = new List<testtest123__JobApp__c>();
        candidate.add(getCandidate());
        insert candidate;
        insert positionsList;
        positionsList = [SELECT Id FROM testtest123__Position__c];
        candidate = [SELECT Id FROM testtest123__Candidate__c];
        for (Integer i = 0; i < numberOfJobApps; i++) {
            jobAppsList.add(getJobApp(positionsList[i].Id, candidate[0].Id));
        }
        insert jobAppsList;
    }

    public static void createCandidates(Integer numberOfCandidates) {
        List<testtest123__Candidate__c> candidatesList = new List<testtest123__Candidate__c>();
        for (Integer i = 0; i < numberOfCandidates; i++) {
            candidatesList.add(getCandidate());
        }
        insert candidatesList;
    }


    public static testtest123__Position__c getOpenedPosition() {
        testtest123__Position__c posOpened = new testtest123__Position__c();
        posOpened.Name = TEST_TEXT_FIELD;
        posOpened.testtest123__Status__c = OPENED;
        posOpened.testtest123__Skills__c = TEST_SKILL;
        posOpened.testtest123__Description__c = TEST_TEXT_FIELD;
        posOpened.testtest123__Contacts__c = TEST_TEXT_FIELD;
        posOpened.testtest123__Requirements__c = TEST_TEXT_FIELD;
        posOpened.testtest123__Location__c = TEST_LOCATION;
        posOpened.testtest123__Date_Opened__c = Date.today();
        return posOpened;
    }

    public static testtest123__Position__c getClosedPosition() {
        testtest123__Position__c posClosed = new testtest123__Position__c();
        posClosed.Name = TEST_TEXT_FIELD;
        posClosed.testtest123__Status__c = CLOSED;
        posClosed.testtest123__Description__c = TEST_TEXT_FIELD;
        posClosed.testtest123__Contacts__c = TEST_TEXT_FIELD;
        posClosed.testtest123__Requirements__c = TEST_TEXT_FIELD;
        posClosed.testtest123__Location__c = TEST_LOCATION;
        posClosed.testtest123__Date_Opened__c = Date.today();
        return posClosed;
    }

    public static testtest123__Candidate__c getCandidate() {
        testtest123__Candidate__c candidate = new testtest123__Candidate__c();
        candidate.Name = TEST_TEXT_FIELD;
        candidate.testtest123__Address__c = TEST_TEXT_FIELD;
        candidate.testtest123__Phone_Number__c = TEST_PHONE_NUMBER;
        candidate.testtest123__Email__c = TEST_EMAIL;
        return candidate;
    }

    public static testtest123__JobApp__c getJobApp(Id positionId, Id candidateId) {
        testtest123__JobApp__c jobApp = new testtest123__JobApp__c();
        jobApp.testtest123__Stage__c = FIRST_STAGE;
        jobApp.testtest123__Resume__c = TEST_URL;
        jobApp.testtest123__Candidate__c = candidateId;
        jobApp.testtest123__Position__c = positionId;
        return jobApp;
    }
    public static User createStandartEmployee() {
        String uniqueUserName = TEST_USER_NAME + DateTime.now().getTime() + TEST_ORG;
        Profile profile = [SELECT Id FROM Profile WHERE Name=: STANDART_EMPLOYEE_PROFILE];
        User testUser = new User(Alias = TEST_ALIAS, 
            Email= TEST_EMAIL,
            EmailEncodingKey = UTF_8, 
            LastName = TEST_TEXT_FIELD, 
            LanguageLocaleKey = EN_LANGUAGE,
            LocaleSidKey = EN_LANGUAGE, ProfileId = profile.Id,
            TimeZoneSidKey = TEST_TIME_ZONE,
            UserName=uniqueUserName);
        System.debug(testUser);
        return testUser;
    }
}