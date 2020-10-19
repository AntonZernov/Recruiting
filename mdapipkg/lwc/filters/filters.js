import { LightningElement, wire, api } from 'lwc';
import getPicklistOptions from '@salesforce/apex/FiltersController.getPicklistOptions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import SOME_ERROR from '@salesforce/label/c.Some_error';
import CLEAR_FILTERS from '@salesforce/label/c.Clear_filters';

const VARIANT_ERROR = 'warning';

export default class Filters extends LightningElement {
    label = {
        CLEAR_FILTERS, 
    };
    
    fieldsOptions = [];
    error;
    value = [];
    @wire(getPicklistOptions)
    getOptions({data, error}) {
        if (data) {
            this.fieldsOptions = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.fieldsOptions = undefined;
            this.showToast(ERROR_LABEL, SOME_ERROR, VARIANT_ERROR);
            console.error(error.body.message);
        }
    }

    @api
    removeFilter(name) {
        for (const checkbox of this.template.querySelectorAll('lightning-checkbox-group')) {
            if (checkbox.name === name) {
                checkbox.value = [];
            }
        }
    }

    handleChange(event) {
        this.dispatchEvent(new CustomEvent('apply',{
            detail: {name: event.target.name, value: event.detail.value }
        }));
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

    handleClearAllFilters() {
        for (const checkbox of this.template.querySelectorAll('lightning-checkbox-group')) {
            checkbox.value = [];
        }
        this.dispatchEvent(new CustomEvent('clear'));
    }
}