trigger ActionItemTrigger on Action_Item__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    new ActionItemTriggerHandler().run(Trigger_Setting__c.Disable_Action_Item_Trigger__c);
}