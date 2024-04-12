public virtual class TriggerHandler {

    public void run(Schema.SObjectField isTriggerDisabled) {
        if((Boolean)Trigger_Setting__c.getInstance().get(isTriggerDisabled)) {
            return ;
        }

        if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
            this.beforeInsert();
        }
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
            this.afterInsert();
        }
        if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
            this.beforeUpdate();
        }
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
            this.afterUpdate();
        }
        if(Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) {
            this.beforeDelete();
        }
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) {
            this.afterDelete();
        }
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) {
            this.afterUndelete();
        }
    }

    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void beforeDelete(){}
    @TestVisible
    protected virtual void afterInsert(){}
    @TestVisible
    protected virtual void afterUpdate(){}
    @TestVisible
    protected virtual void afterDelete(){}
    @TestVisible
    protected virtual void afterUndelete(){}
}