import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getPositionFields from '@salesforce/apex/PositionDetailController.getPositionFields';
import getJobApps from '@salesforce/apex/PositionDetailController.getJobApps';
import getPositionClosedStatus from '@salesforce/apex/PositionDetailController.getPositionClosedStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Position__c.Status__c';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import SOME_ERROR from '@salesforce/label/c.Some_error';
import CREATED_BY_LABEL from '@salesforce/label/c.Created_By';
import CREATE_NEW_JOBAPP_LABEL from '@salesforce/label/c.Create_new_JobApp';
import LAST_MODIFIED_BY_LABEL from '@salesforce/label/c.Last_Modified_By';
import JOB_APPS_LIST_LABEL from '@salesforce/label/c.Job_apps_list';
import SAVE_LABEL from '@salesforce/label/c.Save';
import CANCEL_LABEL from '@salesforce/label/c.Cancel';

const VARIANT_ERROR = 'warning';

export default class PositionDetail extends NavigationMixin(LightningElement) {
    label = {
        CREATED_BY_LABEL, LAST_MODIFIED_BY_LABEL, CREATE_NEW_JOBAPP_LABEL, JOB_APPS_LIST_LABEL,
        SAVE_LABEL, CANCEL_LABEL,
      };

    @track positionId;
    @track positionDetailId;
    @track jobApps;
    @track showJobApps = false;
    @track showJobAppCreationForm = false;
    @track position;
    @track buttonDisabled;
    error;
    refresher;
    @api
    setPositionId(positionId) {
        this.showJobApps = false;
        this.positionId = positionId;
    }
    @wire(getPositionFields, {positionId: '$positionId'})
    setPositions(value) {
        const {error, data} = value;
        if (data) {
            this.position = data;
            this.positionDetailId = this.positionId;
            this.error = undefined;
            
        } else if (error) {
            this.error = error;
            this.position = undefined;
            this.showToast(ERROR_LABEL, SOME_ERROR, VARIANT_ERROR);
            console.error(error.body.message);
        }
    }

    @wire(getJobApps, {positionId: '$positionDetailId'})
    setJobApps(value) {
        this.refresher = value;
        const {error, data} = value;
        if (data) {
            this.jobApps = data;
            if (this.jobApps.length > 0) {
                this.showJobApps = true;
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.jobApps = undefined;
            this.showToast(ERROR_LABEL, SOME_ERROR, VARIANT_ERROR);
            console.error(error.body.message);
        }
    }

    @wire(getPositionClosedStatus) 
    closedStatus;

    @wire(getRecord, { recordId: '$positionId', fields: [STATUS_FIELD] })
    record;

    getStatusValue() {
        return this.record.data ? getFieldValue(this.record.data, STATUS_FIELD) : '';
    }

    handleButtonDisabled() {
        if (this.getStatusValue() === this.closedStatus.data) {
            this.buttonDisabled = true;
        } else {
            this.buttonDisabled = false;
        }
    }

    renderedCallback() {
        this.handleButtonDisabled();
    }

    handleShowJobAppCreationForm() {
        this.showJobAppCreationForm = true;
    }

    handleCancel() {
        this.showJobAppCreationForm = false;
    }

    handleSave() {
        this.template.querySelector('c-create-job-app').saveJobApp(this.positionDetailId);
    }

    handleSuccess() {
        refreshApex(this.refresher);
        this.showJobAppCreationForm = false;
    }

    handleRedirectToPositionRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.positionDetailId,
                actionName: 'view'
            }
        });
    }
    handleRedirectToJobAppRecordPage(event) {
        let jobAppId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: jobAppId,
                actionName: 'view'
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