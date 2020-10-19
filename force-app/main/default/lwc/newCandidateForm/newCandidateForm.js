import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFieldNames from '@salesforce/apex/NewCandidateFormController.getFieldNames';
import SUCCESS_LABEL from '@salesforce/label/c.Success';
import SUCCESS_MESSAGE from '@salesforce/label/c.Candidate_created';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import SOME_ERROR from '@salesforce/label/c.Some_error';
import NEW_CANDIDATE_LABEL from '@salesforce/label/c.New_candidate';
import SAVE_LABEL from '@salesforce/label/c.Save';
import CANCEL_LABEL from '@salesforce/label/c.Cancel';

const VARIANT_ERROR = 'warning';
const VARIANT_SUCCESS = 'success';

export default class NewCandidateForm extends NavigationMixin(LightningElement) {
    listOfFields;
    error;
    
    label = {
        SAVE_LABEL, NEW_CANDIDATE_LABEL, CANCEL_LABEL
    };

    @wire(getFieldNames)
    candidateFields({data, error}) {
        if(data) {
            this.listOfFields = data;
            this.error = undefined;
        }
        else if(error) {
            this.error = error;
            this.listOfFields = undefined;
            this.showToast(ERROR_LABEL, SOME_ERROR, VARIANT_ERROR);
            console.error(error);
        }
    }

    saveJobApp(candidateId) {
        this.template.querySelector('c-new-job-app-form').saveJobApp(candidateId);
    }

    handleSuccess(event) {
        this.showToast(SUCCESS_LABEL, SUCCESS_MESSAGE, VARIANT_SUCCESS);
        this.saveJobApp(event.detail.id);
        this.redirectToCandidateRecordPage(event.detail.id);
    }

    handleCancel() {
        this.redirectToCandidatesTab();
    }
    
    redirectToCandidateRecordPage(candidateId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: candidateId,
                actionName: 'view'
            }
        });
    }

    redirectToCandidatesTab() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'testtest123__Candidate__c',
                actionName: 'list'
            }
        });
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