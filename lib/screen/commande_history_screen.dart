import 'package:delivery_app/providers/commande_history.dart';
import 'package:delivery_app/widgets/cmd_history_item.dart' as cmdHistWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


class CommandeHistoryScreen extends StatefulWidget {
  static const routeName = '/history';

  @override
  _CommandeHistoryScreenState createState() => _CommandeHistoryScreenState();
}

class _CommandeHistoryScreenState extends State<CommandeHistoryScreen> {
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true; 
      });

      Provider.of<CommandeHistory>(context).fetchAndSetCommandeHistory().then((_) {
        setState(() {
          _isLoading = false; 
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshCmdHistory() async {
    await Provider.of<CommandeHistory>(context).fetchAndSetCommandeHistory();
  }

  @override
  Widget build(BuildContext context) {
    final cmdHistoryData = Provider.of<CommandeHistory>(context, listen: false);
    final cmdHistory = cmdHistoryData.commandesHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text('HISTORIQUES DES VENTES'),
        centerTitle: true,
        
      ),

      body: RefreshIndicator(
        onRefresh: () => _refreshCmdHistory(),

        child: (_isLoading)
        ? Center(child: SpinKitChasingDots(color: Colors.redAccent, size: 50,))
        : ListView.builder(
          itemCount: cmdHistory.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: cmdHistory[i],
            child: cmdHistWidget.CmdHistoryItem(
              //all propr
            ),
          ) ,
        )
      )
    );
  }
}