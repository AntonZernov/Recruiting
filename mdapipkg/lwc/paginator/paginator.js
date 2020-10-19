import { LightningElement, api } from 'lwc';
import NEXT_LABEL from '@salesforce/label/c.Next';
import PREVIOUS_LABEL from '@salesforce/label/c.Previous';
const NEXT_NAME = 'Next';
const PREVIOUS_NAME = 'Previous';

export default class Paginator extends LightningElement {
    @api itemsCount;
    @api itemsPerPage;
    @api currentPage;

    label = {
        NEXT_LABEL, PREVIOUS_LABEL,
    };
    
    buttonsName = {
        NEXT_NAME, PREVIOUS_NAME,
    };

    get buttons() {
        let buttons = [];
        for (let i = 1; i <= this.getNumberOfPages(); i++) {
            buttons.push({label: i, disabled: i === this.currentPage})
        }
        return buttons;
    }

    get nextDisabled() {
        return this.currentPage === this.getNumberOfPages();
    }

    get previousDisabled() {
        return this.currentPage === 1;
    }

    getNumberOfPages() {
        return Math.ceil(this.itemsCount / this.itemsPerPage);
    }

    handleChoosePage(event) {
        let page;
        if (event.target.name === 'Next') {
            page = this.currentPage + 1;
          } else if (event.target.name === 'Previous') {
            page = this.currentPage - 1;
          } else page = event.target.name;
        this.dispatchEvent(new CustomEvent('choosepage',{
            detail: page
        }));
    }
}