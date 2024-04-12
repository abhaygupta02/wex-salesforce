public class ActionItemService {

    public static void updateMileStoneCompletion(List<Action_Item__c> newList) {
        Set<Id> milestoneIds = new Set<Id>();
        for(Action_Item__c actionItem : newList) {
            System.debug(actionItem);
            milestoneIds.add(actionItem.Milestone__c);
        }

        Map<Id, Integer> milestoneVsIncompleteActionItemsCountMap = new Map<Id, Integer>();
        for (AggregateResult aggregate : [
                                                SELECT Milestone__c, COUNT(Id) incompleteActionItemsCount
                                                FROM Action_Item__c
                                                WHERE Milestone__c IN :milestoneIds AND Status__c = 'Incomplete'
                                                GROUP BY Milestone__c
                                        ]) {
            
            milestoneVsIncompleteActionItemsCountMap.put((Id)aggregate.get('Milestone__c'), (Integer)aggregate.get('incompleteActionItemsCount'));
        }

        Map<Id, Integer> mileStoneVsActionItemCountMap = new Map<Id, Integer>();
        List<Action_Item__c> actionItems = [SELECT Id, Milestone__c FROM Action_Item__c WHERE Milestone__c IN:milestoneIds];

        for(Action_Item__c actionItem : actionItems) {
            if(mileStoneVsActionItemCountMap.containsKey(actionItem.Milestone__c)) {
                mileStoneVsActionItemCountMap.put(actionItem.Milestone__c, mileStoneVsActionItemCountMap.get(actionItem.Milestone__c) + 1);
            } else {
                mileStoneVsActionItemCountMap.put(actionItem.Milestone__c, 1);
            }
        }
    
        List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
        for (Id milestoneId : milestoneIds) {
            Double totalActionItems = mileStoneVsActionItemCountMap.get(milestoneId);
            Double incompleteActionItemsCount = 0;
            if(milestoneVsIncompleteActionItemsCountMap.get(milestoneId) != null) {
                incompleteActionItemsCount = milestoneVsIncompleteActionItemsCountMap.get(milestoneId);
            }
            System.debug(totalActionItems + ' '+incompleteActionItemsCount + ' '+ mileStoneVsActionItemCountMap.get(milestoneId) + ' '+ milestoneVsIncompleteActionItemsCountMap.get(milestoneId)+ ' '+(totalActionItems - incompleteActionItemsCount));
            Milestone__c milestone = new Milestone__c(Id = milestoneId);
            System.debug(totalActionItems == 0 ? 0 : ((totalActionItems - incompleteActionItemsCount) / totalActionItems) * 100);
            Double percentage = getPercentage(totalActionItems, incompleteActionItemsCount);
            String status = MilestoneService.getStatus(percentage);
            milestone.MileStone_Percentage_Completion__c = percentage;
            milestone.Status__c = status;
            System.debug(milestone);
            milestonesToUpdate.add(milestone);
        }

        if(!milestonesToUpdate.isEmpty()) {
            update milestonesToUpdate;
        }
    }

    public static Double getPercentage(Double totalActionItems, Double incompleteActionItemsCount) {
        Double completeActionItems = totalActionItems - incompleteActionItemsCount;
        System.debug(completeActionItems);
        Double percentFactor = completeActionItems / totalActionItems;
        System.debug(percentFactor);
        Double percentageCompletion = percentFactor * 100;
        System.debug(percentageCompletion);
        return percentageCompletion;
    }

    @AuraEnabled
    public static void createToDoRecords(String nameAndStatusMap) {
        System.debug(nameAndStatusMap);
        List<Action_Item__c> actionItemList = new List<Action_Item__c>();
        List<ActionItemService.ToDoFieldValues> toDoFieldValuesList = (List<ActionItemService.ToDoFieldValues>) JSON.deserialize(nameAndStatusMap, List<ActionItemService.ToDoFieldValues>.class);
        
        for(ToDoFieldValues tdv: toDoFieldValuesList) {
            Action_Item__c actionItem = new Action_Item__c(Name = tdv.Name, Status__c = tdv.status, Milestone__c = tdv.milestoneid);
            actionItemList.add(actionItem);
        }

        if(!actionItemList.isEmpty()) {
            insert actionItemList;
        }
    } 

    public class ToDoFieldValues {
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public String milestoneid { get; set; }
    }
}