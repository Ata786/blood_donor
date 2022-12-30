import 'dart:convert';
import 'package:blood_bank/logic/signup_data.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
// Future<DeployedContract>

  const String PRIVATE_KEY = '0bd53b1874dab78c59da7de0cd7b12da50d5b24cc5925fa09c8b4b3354585674';

   Future<DeployedContract> loadContract()async{
    String abi = await rootBundle.loadString('src/contracts/Blood.json');
    final jsonAbi = jsonDecode(abi);
    String abiCode = jsonEncode(jsonAbi["abi"]);
    EthereumAddress contractAddress = EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    DeployedContract contract = DeployedContract(ContractAbi.fromJson(abiCode, 'Blood'), contractAddress);
    return contract;
  }

  Future functionCall(String functionName,Web3Client web3client,String privateKey,List<dynamic> args)async{
    EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await web3client.sendTransaction(ethPrivateKey,
        Transaction.callContract(contract: contract, function: ethFunction, parameters: args));
     return result;
  }

  void setUser(int type,String _id,String _name,String _email,String contact,String _bloodGroup,Web3Client web3client)async{
      await functionCall('setUser', web3client, PRIVATE_KEY,
          [BigInt.from(type),_id,_name,_email,contact,_bloodGroup]);
  }

void setRequest(String id,String name,String number,String reason,String bloodGroup,String hospitalName,Web3Client web3client)async{
  await functionCall('setRequest', web3client, PRIVATE_KEY,
      [id,name,number,reason,bloodGroup,hospitalName]);
}

  Future getFunction(String functionName,Web3Client web3client,List<dynamic> args)async{
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = web3client.call(contract: contract, function: ethFunction, params: args);

    return result;
  }