public inherited sharing class PositionsHelper {
    public static final String ALL = 'All';
    public static final String NAME = 'Name';
    public static final String CLOSED = 'Closed';
    public static final String OPENED = 'Opened';
    public static final String HIRED = 'Hired';
    public static final String CREATED_BY_ID = 'CreatedById';
    public static final String LAST_MODIFIED_BY_ID = 'LastModifiedById';
    public static final String STATUS_FIELD_LABEL = 'Status';
    public static final String LOCATION_FIELD_LABEL = 'Position Location';
    public static final String SKILLS_FIELD_LABEL = 'Skills';
    public static final String NO_ACCESS = System.Label.No_access;
    public static final String NO_UPDATE = System.Label.No_update_rights;
    public static final String NEGATIVE_RECORDS_PER_PAGE_ERROR = System.Label.Negative_records_number;
    public static final String TOO_MUCH_RECORDS_PER_PAGE_ERROR = System.Label.Too_much_records;
    public static final String STATUS_VALUE_ERROR = System.Label.Error_status_value;
    public static final String CURRENT_PAGE_ERROR = System.Label.Current_page_error;
    public static final String POSITION_OBJECT = 'testtest123__Position__c';
    public static final String[] POSITION_STATUS = new String[]{'testtest123__Status__c'};
    public static final String[] POSITION_FIELDS = new String[]{'Name', 'testtest123__Status__c', 
        'testtest123__Date_Opened__c', 'testtest123__Date_Closed__c', 'testtest123__Min_Salary__c', 
        'testtest123__Max_Salary__c'};         
    public static final Integer MAX_QUERY_LIMIT = 50000;
    public static final Integer MAX_SOSL_LIMIT = 2000;
    public static final Integer MIN_QUERY_LIMIT = 0;
    public static final Integer MIN_CURRENT_PAGE = 1;

    public static List<testtest123__Position__c> getPositions(String status) {
        if (!hasReadAccess(POSITION_OBJECT, POSITION_FIELDS)) {
            throw new SecurityException(NO_ACCESS);
        }
        if (!isStatusCorrect(status)) {
            throw new IllegalArgumentException(STATUS_VALUE_ERROR);
        }
        if (status == ALL) {
            return  [SELECT Id, Name, testtest123__Status__c, testtest123__Date_Opened__c, testtest123__Date_Closed__c, 
                testtest123__Min_Salary__c, testtest123__Max_Salary__c FROM testtest123__Position__c WITH SECURITY_ENFORCED 
                ORDER BY CreatedDate LIMIT : MAX_QUERY_LIMIT];
        }   else {
            return  [SELECT Id, Name, testtest123__Status__c, testtest123__Date_Opened__c, testtest123__Date_Closed__c, 
                testtest123__Min_Salary__c, testtest123__Max_Salary__c FROM testtest123__Position__c 
                WHERE testtest123__Status__c =: status WITH SECURITY_ENFORCED 
                ORDER BY CreatedDate LIMIT : MAX_QUERY_LIMIT];
        }
    }
    public static List<Position__c> getPositions(String status, Integer positionsPerPage, Integer currentPage) {
        checkValidity(status, positionsPerPage, currentPage);
        Integer offset = (currentPage-1)*positionsPerPage;
        if (status == All) {
            return [SELECT Id, Name, Status__c, Date_Opened__c, Date_Closed__c, Min_Salary__c,
            Max_Salary__c FROM Position__c ORDER BY CreatedDate LIMIT :positionsPerPage OFFSET :offset];
        } else {
            return [SELECT Id, Name, Status__c, Date_Opened__c, Date_Closed__c, Min_Salary__c,
            Max_Salary__c FROM Position__c WHERE 
            Status__c =: status ORDER BY CreatedDate LIMIT :positionsPerPage OFFSET :offset];
        }
    }
    public static List<PositionsFieldsWrapper> getPositionsFiltered(List<String> status, List<String> location,
            List<String> skills, Integer positionsPerPage, Integer currentPage, String order, 
            String searchString, String searchMode) {
        List<PositionsFieldsWrapper> positionsWrapperList = new List<PositionsFieldsWrapper>();
        List<Position__c> positions = new List<Position__c>();
        if (searchString.length() > 1) {
            positions = searchPositions(searchString, searchMode, status, location, skills, order);
        } else {
            positions = getPositionsFilteredSOQL(status, location, skills, positionsPerPage, currentPage, order);
        }
        for (Position__c position : positions) {
            PositionsFieldsWrapper positionWrapper = new PositionsFieldsWrapper(position.Name, position.Id);
            for (String field : getPicklistFieldNames()) {
                positionWrapper.fields.add(position.get(field));
            }
            positionsWrapperList.add(positionWrapper);
        }
        return positionsWrapperList;
    }
    public static List<Position__c> getPositionsFilteredSOQL(List<String> status, List<String> location,
            List<String> skills, Integer positionsPerPage, Integer currentPage, String order) {
        Integer offset = (currentPage-1)*positionsPerPage;
        String whereClause;
        List<String> whereClausesList = new List<String>();
        List<Position__c> positionsList = new List<Position__c>();
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        String fieldsQuery = String.join(getFieldNames(), ' ,');
        if (status.size() > 0) {
            for (Integer i = 0; i < status.size(); i++) {
                statusList.add(' Status__c =:' + status[i] + ' ');
            }
            whereClausesList.add(' (' + String.join(statusList, 'OR') + ') ');
        }
        if (location.size() > 0) {
            for (Integer i = 0; i < location.size(); i++) {
                locationList.add(' Location__c = \'' + location[i] + '\' ');
            }
            whereClausesList.add(' (' + String.join(locationList, 'OR') + ') ');
        }
        if (skills.size() > 0) {
            for (Integer i = 0; i < skills.size(); i++) {
                skillsList.add(' Skills__c includes (\'' + skills[i] + '\') ');
            }
            whereClausesList.add(' (' + String.join(skillsList, 'AND') + ') ');
        }
        if (whereClausesList.size() == 0) {
            whereClause = '';
        } else {
            whereClause = 'WHERE' + String.join(whereClausesList, 'AND');
        }
        System.debug('SELECT ' + fieldsQuery + ' FROM Position__c ' + 
            whereClause + ' ORDER BY ' + order + ' LIMIT :positionsPerPage OFFSET :offset');
        positionsList =  Database.query('SELECT ' + fieldsQuery + ' FROM Position__c ' + 
            whereClause + ' ORDER BY ' + order + ' LIMIT :positionsPerPage OFFSET :offset');
        return positionsList;
    }

    public static PositionsFieldsWrapper getPositionDetailFields(Id positionId) {
        PositionsFieldsWrapper positionWrapper = new PositionsFieldsWrapper();
        List<String> fields = getPositionDetailFieldNames();
        Position__c position = new Position__c();
        Boolean showUserPhoto = SettingsHelper.getRecruitingMetadata().testtest123__Show_user_photo__c;
        position = getUserNameAndPhotoURL(positionId);
        for (String field : fields) {
            if (field == NAME) {
                positionWrapper.name = position.Name;
                continue;
            }
            if (field == CREATED_BY_ID) {
                positionWrapper.createdByName = position.CreatedBy.Name;
                if (showUserPhoto) {
                    positionWrapper.createdByPhotoURL = position.CreatedBy.SmallPhotoUrl;
                }
                continue;
            }
            if (field == LAST_MODIFIED_BY_ID) {
                positionWrapper.lastModifiedByName = position.LastModifiedBy.Name;
                if (showUserPhoto) {
                    positionWrapper.lastModifiedByPhotoURL = position.LastModifiedBy.SmallPhotoUrl;
                }
                continue;
            }
            positionWrapper.fields.add(field);
        }
        return positionWrapper;
    }

    public static Position__c getUserNameAndPhotoURL(Id positionId) {
        Position__c position = [SELECT Name, createdBy.Name, createdBy.SmallPhotoURL, lastModifiedBy.Name, 
            lastModifiedBy.SmallPhotoUrl FROM Position__c WHERE ID =: positionId];
        return position;
    }
    
    public static List<Position__c> searchPositions(String searchString, String searchMode, List<String> status, 
            List<String> location, List<String> skills, String order) {
        List<String> whereClausesList = new List<String>();
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        String fieldsQuery = String.join(getFieldNames(), ' ,');
        String whereClause;
        List<Position__c> positionsList = new List<Position__c>();
        if (status.size() > 0) {
            for (Integer i = 0; i < status.size(); i++) {
                statusList.add(' testtest123__Status__c =:' + status[i] + ' ');
            }
            whereClausesList.add(' (' + String.join(statusList, 'OR') + ') ');
        }
        if (location.size() > 0) {
            for (Integer i = 0; i < location.size(); i++) {
                locationList.add(' testtest123__Location__c = \'' + location[i] + '\' ');
            }
            whereClausesList.add(' (' + String.join(locationList, 'OR') + ') ');
        }
        if (skills.size() > 0) {
            for (Integer i = 0; i < skills.size(); i++) {
                skillsList.add(' testtest123__Skills__c includes (\'' + skills[i] + '\') ');
            }
            whereClausesList.add(' (' + String.join(skillsList, 'AND') + ') ');
        }
        if (whereClausesList.size() == 0) {
            whereClause = '';
        } else {
            whereClause = 'WHERE' + String.join(whereClausesList, 'AND');
        }

        System.debug('FIND \'' + searchString + 
            '*\' IN ' + searchMode + ' RETURNING testtest123__Position__c (' + fieldsQuery + ' '+ whereClause +
            ' ORDER BY ' + order + ') LIMIT ' + String.valueOf(MAX_SOSL_LIMIT));
        List<List<Position__c>> searchResult = search.query('FIND \'' + searchString + 
            '*\' IN ' + searchMode + ' RETURNING testtest123__Position__c (' + fieldsQuery + ' '+ whereClause +
            ' ORDER BY ' + order + ') LIMIT ' + String.valueOf(MAX_SOSL_LIMIT));
        positionsList = searchResult.get(0);
        return positionsList;
    }

    public static List<String> getFieldNames() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Position_fieldset__c;
        List<String> fields = new List<String>();
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            fields.add(fieldSetMember.getSObjectField().getDescribe().getName());
        }
        return fields;
    }
    
    public static List<PositionsFieldsWrapper> getPositionsFieldLabels(String fieldSetApiName, Boolean onlyAccessible) {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        Boolean fieldAccessible;
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            if (onlyAccessible) {
                fieldAccessible = CandidateHelper.isFieldAccessible(POSITION_OBJECT, 
                    fieldSetMember.getSObjectField().getDescribe().getName());
                if (fieldAccessible) {
                    PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper();
                    wrapper.fieldLabel = fieldSetMember.getSObjectField().getDescribe().getLabel();
                    fields.add(wrapper);
                } else {
                    continue;
                }
            } else {
                PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper();
                wrapper.fieldLabel = fieldSetMember.getSObjectField().getDescribe().getLabel();
                wrapper.fieldAccessible = CandidateHelper.isFieldAccessible(POSITION_OBJECT, 
                    fieldSetMember.getSObjectField().getDescribe().getName());
                fields.add(wrapper);
            }
        }
        return fields;
    }

    public static List<String> getPositionDetailFieldNames() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Position_detail_fields__c;
        List<String> fields = new List<String>();
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            fields.add(fieldSetMember.getSObjectField().getDescribe().getName());
        }
        return fields;
    }

    public static List<String> getPicklistFieldNames(){
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Position_fieldset__c;
        List<String> fields = new List<String>();
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            if ((fieldSetMember.getSObjectField().getDescribe().getType() == Schema.DisplayType.PICKLIST) ||
                (fieldSetMember.getSObjectField().getDescribe().getType() == Schema.DisplayType.MULTIPICKLIST)) {
                fields.add(fieldSetMember.getSObjectField().getDescribe().getName());
            }
        }
        return fields;
    }

    public static List<PositionsPicklistFields> getPicklistOptions() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Position_filter_fieldset__c;
        List<String> fields = new List<String>();
        List<PositionsPicklistFields> positionsPicklistFieldsList = new List<PositionsPicklistFields>();
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            if ((fieldSetMember.getSObjectField().getDescribe().getType() == Schema.DisplayType.PICKLIST) ||
                (fieldSetMember.getSObjectField().getDescribe().getType() == Schema.DisplayType.MULTIPICKLIST)) {
                fields.add(fieldSetMember.getSObjectField().getDescribe().getLabel());
            }
        }
        for (String field : fields) {
            PositionsPicklistFields positionsPicklistFields = new PositionsPicklistFields(field);
            if (field == STATUS_FIELD_LABEL) {
                for (Schema.PicklistEntry pickListEntry : getPositionsStatusValues()) {
                    positionsPicklistFields.options.add(new PositionsOptions(pickListEntry.getValue(), 
                        pickListEntry.getValue()));
                }
            }
            if (field == LOCATION_FIELD_LABEL) {
                for (Schema.PicklistEntry pickListEntry : getPositionsLocationValues()) {
                    positionsPicklistFields.options.add(new PositionsOptions(pickListEntry.getValue(), 
                    pickListEntry.getValue()));
                }
            }
            if (field == SKILLS_FIELD_LABEL) {
                for (Schema.PicklistEntry pickListEntry : getPositionsSkillsValues()) {
                    positionsPicklistFields.options.add(new PositionsOptions(pickListEntry.getValue(), 
                    pickListEntry.getValue()));
                }
            }
            positionsPicklistFieldsList.add(positionsPicklistFields);
            }
            return positionsPicklistFieldsList;
    }
    

    @testVisible
    private static List<Schema.FieldSetMember> getFieldSetMemberList(String fieldSetApiName) {
        List<Schema.FieldSetMember> fieldSetMembersList = new List<Schema.FieldSetMember>();
        Schema.DescribeSObjectResult objectDescribe = testtest123__Position__c.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        fieldSetMembersList = fieldSetMap.get(fieldSetApiName).getFields();
        return fieldSetMembersList;
    }

    private static void checkValidity(String status, Integer positionsPerPage, Integer currentPage) {
        if (!hasReadAccess(POSITION_OBJECT, POSITION_FIELDS)) {
            throw new SecurityException(NO_ACCESS);
        }
        if (positionsPerPage < MIN_QUERY_LIMIT) {
            throw new IllegalArgumentException(NEGATIVE_RECORDS_PER_PAGE_ERROR);
        }
        if (currentPage < MIN_CURRENT_PAGE) {
            throw new IllegalArgumentException(CURRENT_PAGE_ERROR);
        }
        if (positionsPerPage > MAX_QUERY_LIMIT) {
            throw new IllegalArgumentException(TOO_MUCH_RECORDS_PER_PAGE_ERROR);
        }
        if (!isStatusCorrect(status)) {
            throw new IllegalArgumentException(STATUS_VALUE_ERROR);
        }

    }

    public static void updatePositions(List<Position__c> positions) {
        if (!hasEditAccess(POSITION_OBJECT, POSITION_STATUS)) {
            throw new SecurityException(NO_UPDATE);
        }
            update positions;
    }

    public static Integer getPositionsCount(String status) {
        if (!isStatusCorrect(status)) {
            throw new IllegalArgumentException(STATUS_VALUE_ERROR);
        }
        if (status == All) {
            return [SELECT COUNT() FROM Position__c];
        } else {
            return [SELECT COUNT() FROM Position__c WHERE Status__c =: status];
        }
    }

    public static Integer getPositionsCount(List<String> status, List<String> location, List<String> skills) {
        String whereClause;
        List<String> whereClausesList = new List<String>();
        List<Position__c> positionsList = new List<Position__c>();
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        if (status.size() > 0) {
            for (Integer i = 0; i < status.size(); i++) {
                statusList.add(' Status__c =:' + status[i] + ' ');
            }
            whereClausesList.add(' (' + String.join(statusList, 'OR') + ') ');
        }
        if (location.size() > 0) {
            for (Integer i = 0; i < location.size(); i++) {
                locationList.add(' Location__c = \'' + location[i] + '\' ');
            }
            whereClausesList.add(' (' + String.join(locationList, 'OR') + ') ');
        }
        if (skills.size() > 0) {
            for (Integer i = 0; i < skills.size(); i++) {
                skillsList.add(' Skills__c includes (\'' + skills[i] + '\') ');
            }
            whereClausesList.add(' (' + String.join(skillsList, 'AND') + ') ');
        }

        if (whereClausesList.size() == 0) {
            whereClause = '';
        } else {
            whereClause = 'WHERE' + String.join(whereClausesList, 'AND');
        }
        return Database.countQuery('SELECT COUNT() FROM Position__c ' + whereClause);
    }

    public static List<SelectOption> getFilterOptions() {
        List<SelectOption> filterList = new List<SelectOption>();
        filterList.add(new SelectOption(ALL, ALL));
        for (Schema.PicklistEntry pickListEntry : getPositionsStatusValues()) {
            filterList.add(new SelectOption(pickListEntry.getLabel(), pickListEntry.getValue()));
        }
        return filterList;
    }

    public static List<SelectOption> getPositionsFieldSetSelectOptions() {
        Schema.DescribeSObjectResult objectDescribe = testtest123__Position__c.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> positionFieldSetMap =  objectDescribe.fieldSets.getMap();
        List<SelectOption> optionsList = new List<SelectOption>();
        for (String fieldSet : positionFieldSetMap.keySet()) {
            if (String.isEmpty(positionFieldSetMap.get(fieldSet).getNameSpace())) {
                optionsList.add(new SelectOption(
                positionFieldSetMap.get(fieldSet).getName(), 
                positionFieldSetMap.get(fieldSet).getLabel()));

            } else {
                optionsList.add(new SelectOption(positionFieldSetMap.get(fieldSet).getNameSpace() + '__' +
                                                positionFieldSetMap.get(fieldSet).getName(), 
                                                positionFieldSetMap.get(fieldSet).getLabel()));
                
            }
        }
        return optionsList;
    }
    
    private static List<Schema.PicklistEntry> getPositionsStatusValues() {
        Schema.DescribeFieldResult fieldResult = Position__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntry = fieldResult.getPicklistValues();
        return picklistEntry;
    }
    private static List<Schema.PicklistEntry> getPositionsLocationValues() {
        Schema.DescribeFieldResult fieldResult = Position__c.Location__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntry = fieldResult.getPicklistValues();
        return picklistEntry;
    }
    private static List<Schema.PicklistEntry> getPositionsSkillsValues() {
        Schema.DescribeFieldResult fieldResult = Position__c.Skills__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntry = fieldResult.getPicklistValues();
        return picklistEntry;
    }
    
    private static Boolean hasReadAccess(String objectName, String[] fieldSet) {
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String, Schema.SObjectField> fields = objectDescribe.fields.getMap();
        if (!objectDescribe.isAccessible()) {
            return false;
        }
        for (String field : fieldSet) {
            if (!fields.get(field).getDescribe().isAccessible()) {
                return false;
            } 
        }
        return true;
    }
    @TestVisible
    private static Boolean hasEditAccess(String objectName, String[] fieldSet) {
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String, Schema.SObjectField> fields = objectDescribe.fields.getMap();
        if (!objectDescribe.isUpdateable()) {
            return false;
        }
        for (String field : fieldSet) {
            if (!fields.get(field).getDescribe().isUpdateable()) {
                return false;
            } 
        }
        return true;
    }
    
    private static Boolean isStatusCorrect(String status) {
        if (status == ALL) {
            return true;
        } 
        for (Schema.PicklistEntry pickListEntry : getPositionsStatusValues()) {
            if (status == pickListEntry.getValue()) {
                return true;
            }
        }
        return false;
    }
}