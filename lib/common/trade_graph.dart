

import '../model/liquidity_model.dart';

class TradeGraph {
     Map<String, List<String>> adj={};

    TradeGraph(List<LiquidityModel>data) {
       Map<String, List<String>> val = {};

        
        for (var item in data) {
          var currencyId1=item.currencyId1;
          var currencyId2=item.currencyId2;
          if(val[currencyId1]==null){
            val[currencyId1]=[currencyId2];
          }else{
            (val[currencyId1] as List).add(currencyId2);
          }
          if(val[currencyId2]==null){
            val[currencyId2]=[currencyId1];
          }else{
            (val[currencyId2] as List).add(currencyId1);
          }

        }
        adj=val;
    }

     List<String>? getAdj(String currencyId1){
        return adj[currencyId1.toString()];
    }

    List<List<String>> getPaths(String start, String end, int? lengthLimit) {
        List<List<String>> result = [];
        List<String> path = [start];
         List<List<String>> searchList = [(adj[start]?? [])];

        while (path.length > 0) {
            List<String> searchListHead = searchList.isNotEmpty ?searchList.removeLast(): [];
            
            if (searchListHead.length > 0) {
                String firstNode = searchListHead.removeAt(0);

                path.add(firstNode);
                searchList.add(searchListHead);

                var nextSearchPathItem = (adj[firstNode] ?? []);

                if (nextSearchPathItem.length > 0) {
                    nextSearchPathItem = nextSearchPathItem.where((String m)=> path.indexWhere((String n) => n == m) ==-1).toList();

                    searchList.add(nextSearchPathItem);
                }
            } else if(path.isNotEmpty){
                path.removeLast();
            }

            if (path.length > 0 && path[path.length - 1] == end) {
                result.add([...path]);

                path.removeLast();
                searchList.removeLast();
            }
        }

        return result.where((item) => (lengthLimit !=null? item.length <= lengthLimit : true)).toList();
    }
}

