import { LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAnimalsByRange from '@salesforce/apex/ApexRestCall.getAnimalsByRange';
import saveRecords from '@salesforce/apex/ApexRestCall.saveRecords';

export default class MyFirstLWC extends LightningElement {
    @track itemData = [];
    @track showTable = false;
    @track showSaveChangesBtn = false;
    dataToSave = [];

    selectedRows = [];

    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' },
        { label: 'Eats',  fieldName: 'Eats' },
        { label: 'Says',  fieldName: 'Says' }
    ];

    get startRangeValue() {
        return this.template.querySelector(".start").value;
    }

    get endRangeValue() {
        return this.template.querySelector(".end").value;
    }

    sendRequest() {
        this.getAnimalsByRangeFromApex();
    }

    getAnimalsByRangeFromApex() {
		return getAnimalsByRange({
			startRange: this.startRangeValue,
            endRange: this.endRangeValue,
		})
			.then(data => {
				if (data && data.isSuccess) {
                    this.itemData = data.returnObj;
                    this.showTable = true;
					console.log(this.itemData)
				} else {
					console.error('getAnimalsByRangeFromApex error from apex: ', data.message);
				}
			})
			.catch(error => {
				console.error('getAnimalsByRangeFromApex catch error: ', error);
			});
	}

    selectDeselectCheckboxes(event) {
        let checkBoxIndex = event.currentTarget.dataset.indexNumber;
        let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
        let checked = this.template.querySelectorAll('input[data-id="checkbox"]:checked');
        let mainCheckBox = this.template.querySelector('[data-id="mainCheckbox"]');
    
        if (checkBoxIndex !== 'main') {
            this.handleRowSelection(this.itemData[checkBoxIndex].id, event.target.checked);
            
            if (checked.length === 0) {
                mainCheckBox.checked = false;
                mainCheckBox.indeterminate = false;
            } else if (checked.length !== checkboxes.length) {
                mainCheckBox.checked = false;
                mainCheckBox.indeterminate = true;
            } else {
                mainCheckBox.checked = true;
                mainCheckBox.indeterminate = false;
            }
        } else {
            for (let i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = event.target.checked;
                this.handleRowSelection(this.itemData[i].id, checkboxes[i].checked);
            }
        }
    }

    handleRowSelection(rowId, checked) {
        try{
            if (checked === true && rowId !==0) {
                this.selectedRows.push(rowId);
                this.dataToSave.push(JSON.parse(JSON.stringify(this.itemData[rowId-1])));
            } else {
                this.selectedRows = this.selectedRows.filter((el) => {
                    this.dataToSave.splice(this.dataToSave.findIndex(function(i){
                        return i.id === rowId-1;
                    }), 1);
                    return el !== rowId;
                });
            }

            this.selectedRows = [...new Set(this.selectedRows)];
            if(this.selectedRows.length > 0) {
                this.showSaveChangesBtn = true;
            }
        } catch (error) {
            console.log("error in handler", error)
        }
        
    }

    cancelChanges() {
        this.clearUpdatedRowsData();
        this.showSaveChangesBtn = false;
    }

    clearUpdatedRowsData() {
        let mainCheckBox = this.template.querySelector('[data-id="mainCheckbox"]');
        if(mainCheckBox != undefined){
            mainCheckBox.checked = false;
        }
        let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
        if(checkboxes != undefined){
            for (let i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = false;
            }
        }
        this.selectedRows = [];
        this.dataToSave = [];
    }

    saveChanges() {
        saveRecords({dataToSave : this.dataToSave})
                .then(data => {
                    if (data && data.isSuccess) {
                        this.showNotification("Success", data.returnObj, "success")
                        this.selectedRows = [];
                        this.dataToSave = [];
                        this.showSaveChangesBtn = false;
                        this.showTable = false;
                    } else {
                        console.error('saveRecords error from apex: ', data.message);
                        this.showNotification("Unsuccess", data.returnObj, "warning")
                    }
                })
                .catch(error => {
                    console.error('saveRecords catch error: ', error);
                });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}