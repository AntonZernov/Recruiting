import { LightningElement, wire, track, api } from 'lwc';
import getPositions from '@salesforce/apex/PositionsTableController.getPositions';
import getPositionsCount from '@salesforce/apex/PositionsTableController.getPositionsCount';
import updatePositions from '@salesforce/apex/PositionsTableController.updatePositions';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import STATUS_FIELD from '@salesforce/schema/Position__c.Status__c';
import POSITIONS_OBJECT from '@salesforce/schema/Position__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import ALL_LABEL from '@salesforce/label/c.All';
import SUCCESS_LABEL from '@salesforce/label/c.Success';
import SUCCESS_MESSAGE from '@salesforce/label/c.Successfully_updated';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import ERROR_UPDATE_MESSAGE from '@salesforce/label/c.Error_update_positions';
import ERROR_SECURITY_MESSAGE from '@salesforce/label/c.No_access';
import LABEL_CHANGED from '@salesforce/label/c.Changed';
import FILTER_LABEL from '@salesforce/label/c.Filter_by_status';
import NAME_LABEL from '@salesforce/label/c.Position_name';
import STATUS_LABEL from '@salesforce/label/c.Status';
import DATE_OPENED_LABEL from '@salesforce/label/c.Date_opened';
import DATE_CLOSED_LABEL from '@salesforce/label/c.Date_closed';
import MAX_SALARY_LABEL from '@salesforce/label/c.Max_salary';
import MIN_SALARY_LABEL from '@salesforce/label/c.Min_salary';
import SAVE_LABEL from '@salesforce/label/c.Save';
import CANCEL_LABEL from '@salesforce/label/c.Cancel';
import SAVE_CHANGED_LABEL from '@salesforce/label/c.Save_changed';
import CANCEL_CHANGES_LABEL from '@salesforce/label/c.Cancel_changes';
const VARIANT_ERROR = 'warning';
const VARIANT_SUCCESS = 'success';

export default class PositionsTable extends LightningElement {
  label = {
    ALL_LABEL, FILTER_LABEL, NAME_LABEL, STATUS_LABEL, DATE_OPENED_LABEL, DATE_CLOSED_LABEL,
    MAX_SALARY_LABEL, MIN_SALARY_LABEL, SAVE_LABEL, SAVE_CHANGED_LABEL, CANCEL_LABEL, 
    CANCEL_CHANGES_LABEL,
  };

  @wire(getObjectInfo, { objectApiName: POSITIONS_OBJECT })
  objectInfo;
  @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD})
  statusValues;
  statusFilter = ALL_LABEL;
  @track positions;
  @track buttonsDisabled = true;
  @wire(getPositionsCount, {status: '$statusFilter'})
  positionsCount;
  @api positionsPerPage;
  @track currentPage = 1;
  @track error;
  refresher;
  @wire(getPositions, {status: '$statusFilter', positionsPerPage: '$positionsPerPage', currentPage: '$currentPage'})
  setPositions(value) {
    this.refresher = value;
    const {error, data} = value;
    if (data) {
        this.positions = [];
        for (let position of data)  {
           this.positions.push({position: position, 
                          Status: position.testtest123__Status__c,
                          Label: ''});
        }
    } else if (error) {
      this.showToast(ERROR_LABEL, ERROR_SECURITY_MESSAGE, VARIANT_ERROR);
      console.error(error.body.message);
    }
  }

  get filterOptions() {
    let options = [{ label: ALL_LABEL, value: ALL_LABEL }];
    let label;
    let value;
    for (let i = 0; i < this.statusValues.data.values.length; i++) {
      label = this.statusValues.data.values[i].label;
      value = this.statusValues.data.values[i].value;
      options.push({label: label, value: value});
    }
    return options;
  }

  handleFilter(event) {
    this.statusFilter = event.detail.value;
    this.currentPage = 1;
    this.buttonsDisabled = true;
  }
  
  hasChangedPositions() {
    for (let position of this.positions)  {
      if (position.Status !== position.position.testtest123__Status__c) {
        return true;
      } 
    }
    return false;
  }

  handleStatusChange(event) {
    let index = event.target.dataset.index;
    this.positions[index].Status = event.target.value;
    if (event.target.value !== this.positions[index].position.testtest123__Status__c) {
      this.positions[index].Label = LABEL_CHANGED;
    } else {
      this.positions[index].Label = '';
    }
    this.buttonsDisabled = !this.hasChangedPositions();
  }

  handleSave() {
    let draftPositions = [];
    this.positions.forEach(element => {
      if (element.Status !== element.position.testtest123__Status__c) {
        draftPositions.push({Id: element.position.Id, testtest123__Status__c: element.Status})
      } 
    });
    updatePositions({ positions: draftPositions })
    .then(() => {
        this.showToast(SUCCESS_LABEL, SUCCESS_MESSAGE, VARIANT_SUCCESS);
        this.buttonsDisabled = true;
        this.currentPage = 1;
        refreshApex(this.positionsCount);
        return refreshApex(this.refresher);
      })
      .catch((error) => {
        this.showToast(ERROR_LABEL, ERROR_UPDATE_MESSAGE, VARIANT_ERROR);
        console.error(error);
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

  handleCancel() {
    this.positions.forEach(element => {
      element.Status = element.position.testtest123__Status__c;
      element.Label = '';
    });
    this.buttonsDisabled = true;
  }
      
  handleChoosePage(event) {
    this.buttonsDisabled = true;
    this.currentPage = event.detail;
  }
}