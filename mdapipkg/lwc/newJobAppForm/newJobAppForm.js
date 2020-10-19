import { LightningElement, track, wire, api } from 'lwc';
import getOpenedPositions from '@salesforce/apex/NewJobAppFormController.getOpenedPositions';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import STAGE_FIELD from '@salesforce/schema/JobApp__c.Stage__c';
import CANDIDATE_FIELD from '@salesforce/schema/JobApp__c.Candidate__c';
import JOBAPP_OBJECT from '@salesforce/schema/JobApp__c';
import NEW_JOBAPP_LABEL from '@salesforce/label/c.New_jobApp';
import CANDIDATE_LABEL from '@salesforce/label/c.Candidate';
import POSITION_LABEL from '@salesforce/label/c.Position';
import STAGE_LABEL from '@salesforce/label/c.Stage';
import DESCRIPTION_LABEL from '@salesforce/label/c.Description';
import RESUME_URL from '@salesforce/label/c.Resume_URL';
import SELECT_POSITION from '@salesforce/label/c.Select_position';
import SELECT_STAGE from '@salesforce/label/c.Select_stage';
import SUCCESS_LABEL from '@salesforce/label/c.Success';
import SUCCESS_MESSAGE from '@salesforce/label/c.JobApp_created';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import JOBAPP_CREATE_ERROR from '@salesforce/label/c.JobApp_not_created';

const VARIANT_ERROR = 'warning';
const VARIANT_SUCCESS = 'success';



export default class NewJobAppForm extends LightningElement {
    label = {
        NEW_JOBAPP_LABEL, CANDIDATE_LABEL, POSITION_LABEL, STAGE_LABEL, 
        DESCRIPTION_LABEL, RESUME_URL, SELECT_POSITION, SELECT_STAGE
    };

    @track createdRecordFields = {};
    @wire(getOpenedPositions)
    positions;
    @wire(getObjectInfo, { objectApiName: JOBAPP_OBJECT })
    objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STAGE_FIELD})
    stageValues;
    @api
    saveJobApp(candidateId) {
        if (this.hasEmptyField()) {
            this.showToast(ERROR_LABEL, JOBAPP_CREATE_ERROR, VARIANT_ERROR);
            return;
        } 
        this.createdRecordFields[CANDIDATE_FIELD.fieldApiName] = candidateId;
        const fields = this.createdRecordFields;
        const recordInput = { apiName: JOBAPP_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                this.showToast(SUCCESS_LABEL, SUCCESS_MESSAGE, VARIANT_SUCCESS);
            })
            .catch(error => {
                console.log(error);
                this.showToast(ERROR_LABEL, JOBAPP_CREATE_ERROR, VARIANT_ERROR);
            });
    }

    get stageOptions() {
        let options = [];
        let label;
        let value;
        for (let i = 0; i < this.stageValues.data.values.length; i++) {
          label = this.stageValues.data.values[i].label;
          value = this.stageValues.data.values[i].value;
          options.push({label: label, value: value});
        }
        return options;
      }
    
    get positionsOptions() {
        let options = [];
        let label;
        let value;
        for (let i = 0; i < this.positions.data.length; i++) {
          label = this.positions.data[i].Name;
          value = this.positions.data[i].Id;
          options.push({label: label, value: value});
        }
        return options;
        }

    hasEmptyField() {
        let comboboxAttributes = this.template.querySelectorAll('lightning-combobox');
        let textAreaValue = this.template.querySelectorAll('textarea').value;
        let inputValue = this.template.querySelectorAll('input').value;
        if ((!comboboxAttributes[0].value) ||
            (!comboboxAttributes[1].value) ||
            (textAreaValue === '') ||
            (inputValue === '')) {
            return true;
        } else {
            return false;
        }
    }
    
    handleChange(event) {
        this.createdRecordFields[event.target.dataset.field] = event.target.value;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
              title: title,
              message: message,
              variant: variant
            })
        );
    }

}