import 'package:text_editor/app/db/firestore/dao/dao_anotacao_fire.dart';
import 'package:text_editor/app/db/rest/dao/dao_anotacao_rest.dart';
import 'package:text_editor/app/db/sqlite/dao/dao_anotacao_impl.dart';
import 'package:text_editor/app/domain/entities/anotacao.dart';
import 'package:text_editor/app/domain/interfaces/dao_anotacao.dart';


class DaoAnotacaoSync implements DaoAnotacao{

    DaoAnotacaoImpl _daoLocal = DaoAnotacaoImpl();
    DaoAnotacaoFire _daoCloud = DaoAnotacaoFire();
    DaoAnotacaoRest _daoRest = DaoAnotacaoRest();

    syncCloudDatabase() async {
        var localRes = await _daoLocal.buscar();

        await _daoCloud.dropCollection();
        await _daoRest.dropTable();

        for (var anotacao in localRes){
            await _daoCloud.salvar(anotacao);
            await _daoRest.salvar(anotacao);
        }
    }

    @override
    Future<List<Anotacao>> buscar() async{
        syncCloudDatabase();
        return _daoLocal.buscar();
    }

    @override
    remover(id) async {
        await _daoLocal.remover(id);
    }

    @override
    salvar(Anotacao anotacao) async {
        await _daoLocal.salvar(anotacao);
    }

}