import { LightningElement, wire, track, api } from 'lwc';
import getPositions from '@salesforce/apex/PositionsCardsController.getPositions';
import getPositionsCount from '@salesforce/apex/PositionsCardsController.getPositionsCount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ERROR_LABEL from '@salesforce/label/c.Warning';
import SOME_ERROR from '@salesforce/label/c.Some_error';
import ORDER_BY from '@salesforce/label/c.Sort_order';
import SORT_BY_NAME_ASC from '@salesforce/label/c.Sort_by_Name_ASC';
import SORT_BY_NAME_DESC from '@salesforce/label/c.Sort_by_Name_DESC';
import SORT_BY_DATE_ASC from '@salesforce/label/c.Created_date_ASC';
import SORT_BY_DATE_DESC from '@salesforce/label/c.Created_date_DESC';

const VARIANT_ERROR = 'warning';
const NAME_ASC = 'Name ASC';
const NAME_DESC = 'Name DESC';
const DATE_ASC = 'CreatedDate ASC';
const DATE_DESC = 'CreatedDate DESC';
const STATUS_NAME = 'Status';
const LOCATION_NAME = 'Position Location';
const SKILLS_NAME = 'Skills';

export default class PositionsCards extends LightningElement {
  label = {
    ORDER_BY, 
  };

  @track currentPage = 1;
  @track order = NAME_ASC;
  @track error;
  @track positions;
  @api positionsPerPage;
  @track statusFilter = [];
  @track locationFilter = [];
  @track skillsFilter = [];
  @track pillsItems = [];
  @track searchString = '';
  @track searchMode = '';
  @track showPaginator = true;
  @wire(getPositionsCount, {status: '$statusFilter', location: '$locationFilter', skills: '$skillsFilter'})
  positionsCount;
  @wire(getPositions, {status: '$statusFilter', location: '$locationFilter', skills: '$skillsFilter',
    positionsPerPage: '$positionsPerPage', currentPage: '$currentPage', order: '$order', 
    searchString: '$searchString', searchMode: '$searchMode'})
  setPositions(value) {
    const {error, data} = value;
    if (data) {
          this.positions = data;
          this.error = undefined;
      } else if (error) {
          this.error = error;
          this.positions = undefined;
          this.showToast(ERROR_LABEL, SOME_ERROR, VARIANT_ERROR);
          console.error(error.body.message);
      }
  }

  get sorterOptions() {
    let options = [{ label: SORT_BY_NAME_ASC, value: NAME_ASC },
                   { label: SORT_BY_NAME_DESC, value: NAME_DESC },
                   { label: SORT_BY_DATE_DESC, value: DATE_DESC },
                   { label: SORT_BY_DATE_ASC, value: DATE_ASC }];
    return options;
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

  handleChoosePage(event) {
    this.currentPage = event.detail;
  }

  handleSorter(event) {
    this.order = event.detail.value;
  }

  handleSearch(event) {
    this.searchString = event.detail.searchString;
    this.searchMode = event.detail.searchMode;
    this.currentPage = 1;
    if (event.detail.searchString.length > 1) {
      this.showPaginator = false;
    } else {
      this.showPaginator = true;
    }
  }

  handleFilter(event) {
    this.currentPage = 1;
    if (event.detail.name === STATUS_NAME) {
      this.statusFilter = event.detail.value;
      this.template.querySelector('c-positions-live-search').statusFilter = event.detail.value;
    }
    if (event.detail.name === LOCATION_NAME) {
      this.locationFilter = event.detail.value;
      this.template.querySelector('c-positions-live-search').locationFilter = event.detail.value;
    }
    if (event.detail.name === SKILLS_NAME) {
      this.skillsFilter = event.detail.value;
      this.template.querySelector('c-positions-live-search').skillsFilter = event.detail.value;
    }
    for (let i = 0; i < this.pillsItems.length; i++) {
      if (this.pillsItems[i].name === event.detail.name) {
        this.pillsItems.splice(i, 1);
      }
    }
    if (event.detail.value.length > 0) {
      this.pillsItems.push({name: event.detail.name, label: event.detail.value});
    }
  }

  handleClearAllFilters() {
    this.currentPage = 1;
    this.statusFilter = [];
    this.locationFilter = [];
    this.skillsFilter = [];
    this.pillsItems = [];
  }

  handlePillRemove(event) {
    this.currentPage = 1;
    if (event.detail.item.name === STATUS_NAME) {
      this.statusFilter = [];
    }
    if (event.detail.item.name === LOCATION_NAME) {
      this.locationFilter = [];
    }
    if (event.detail.item.name === SKILLS_NAME) {
      this.skillsFilter = [];
    }
    this.pillsItems.splice(event.detail.index, 1);
    this.template.querySelector('c-filters').removeFilter(event.detail.item.name);
  }

  handleArticleClick(event) {
    let positionId = event.currentTarget.dataset.id;
    this.template.querySelector('c-position-detail').setPositionId(positionId);
    for (const item of this.template.querySelectorAll('article')) {
      if (positionId === item.dataset.id) {
        item.classList.remove('unchecked');
        item.classList.add('checked');
      } else {
        item.classList.remove('checked');
        item.classList.add('unchecked');
      }
    }
  }
}