import { LightningElement, track, api } from 'lwc';
import SEARCH from '@salesforce/label/c.Search';
import SEARCH_IN from '@salesforce/label/c.Search_in';
import POSITION_NAME from '@salesforce/label/c.Position_name';
import ALL_FIELDS from '@salesforce/label/c.All_fields';

export default class PositionsLiveSearch extends LightningElement {
    label = {
        SEARCH, SEARCH_IN,
      };

    radioGroupValue = 'NAME FIELDS';
    @api statusFilter = [];
    @api locationFilter = [];
    @api skillsFilter = [];
  
    @track 
    searchString = '';
    @track 
    fields = 'NAME FIELDS';

    get options() {
        return [
            { label: POSITION_NAME, value: 'NAME FIELDS' },
            { label: ALL_FIELDS, value: 'ALL FIELDS' },
        ];
    }

    handleSearchChange(event) {
        this.dispatchEvent(new CustomEvent('search',{
            detail: {searchString: event.target.value, searchMode: this.fields }
        }));
    }

    handleRadioChange(event) {
        this.dispatchEvent(new CustomEvent('search',{
            detail: {searchString: this.searchString, searchMode: event.target.value }
        }));
    }
}