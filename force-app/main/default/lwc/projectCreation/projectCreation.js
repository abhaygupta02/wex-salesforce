import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createToDoRecords from '@salesforce/apex/ActionItemService.createToDoRecords';

export default class ProjectCreation extends NavigationMixin(LightningElement) {
    @track itemList = [
        {
            id: 0, Name: '', status: '', milestoneid: this.milestoneId
        }
    ];
    keyIndex = 0;
    projectId;
    milestoneId;
    showProjectScreen = true;
    showMileStoneScreen = false;
    showToDoScreen = false;

    handleProjectSuccess(event) {
        this.projectId = event.detail.id;
        this.displayToast('Project Created Successfully');
        this.showProjectScreen = false;
        this.showMileStoneScreen = true;
    }

    handleMileStoneSuccess(event) {
        this.milestoneId = event.detail.id;
        this.displayToast('Milestone Created Successfully');
        this.showMileStoneScreen = false;
        this.showToDoScreen = true;
    }

    handleNameChange(event) {
        const index = event.target.dataset.index;
        this.itemList[index].Name = event.target.value;
        this.itemList[index].milestoneid = this.milestoneId;
    }

    handleStatusChange(event) {
        const index = event.target.dataset.index;
        this.itemList[index].status = event.target.value;
        this.itemList[index].milestoneid = this.milestoneId;
    }

    addRow() {
        ++this.keyIndex;
        let newItem = { id: this.keyIndex, Name: '', status: '', milestoneid: this.milestoneId };
        this.itemList.push(newItem);
    }

    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                returnparseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }

    handleSubmit() {
        var itemListStringified = JSON.stringify(this.itemList);
        console.log(itemListStringified);
        createToDoRecords({
            nameAndStatusMap : itemListStringified
        }).then(response => {

            this.displayToast('To-do Items Created Successfully');
            this.showToDoScreen = false;
            this.showProjectScreen = false;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.projectId,
                    objectApiName: 'Project__c',
                    actionName: 'view'
                }
            });
        }).catch(error => {
            console.log(error.body.message);
        });
    }

    

    displayToast(message) {
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: message,
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
    }

}