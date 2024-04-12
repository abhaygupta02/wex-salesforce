public without sharing class ActionItemTriggerHandler extends TriggerHandler{
    
    public override void afterInsert() {
        ActionItemService.updateMileStoneCompletion((List<Action_Item__c>)Trigger.new);
    }

    public override void afterUpdate() {
        ActionItemService.updateMileStoneCompletion((List<Action_Item__c>)Trigger.new);
    }

}