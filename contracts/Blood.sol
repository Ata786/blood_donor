// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <=0.8.17;

    struct UserStruct{
        string id;
        string name;
        string email;
        string contactNum;
        string bloodGroup;
    }

    struct Request{
        string receiverId;
        string patientName;
        string contactNum;
        string reason;
        string bloodGroup;
        string hospitalAddress;
    }

contract Donation{

    UserStruct [] receiver;
    UserStruct [] donor;
    Request [] request;
    Request [] userRequests;
    UserStruct [] availableDonors;

    enum USERTYPE{Donor,Receiver}

    mapping(string => uint) _receiverId;
    mapping(string => uint) _donorId;
    mapping(string => Request[]) _requestId;
    mapping(string=> uint) _avaibilityId;

    event User(string message,string _id);

    function setUser(USERTYPE _userType,string memory _id,string memory _name,string memory _email,string memory contact,string memory _bloodGroup)public{
        if(_userType == USERTYPE.Donor){
            uint index = donor.length;
            donor.push();
            donor[index].id = _id;
            donor[index].name = _name;
            donor[index].email = _email;
            donor[index].contactNum = contact;
            donor[index].bloodGroup = _bloodGroup;

            _donorId[_id] = index;

            emit User("Donor Created Successfully",_id);
        }else{
            uint index = receiver.length;
            UserStruct memory _receiver = UserStruct({
            id: _id,
            name: _name,
            email: _email,
            contactNum: contact,
            bloodGroup: _bloodGroup
            });
            _receiverId[_id] = index;
            receiver.push(_receiver);

            emit User("Receiver Created Successfully",_id);
        }
    }

    function setRequest(string memory id,string memory name,string memory number,string memory reason,string memory bloodGroup,string memory hospitalName)public{
        Request memory _request = Request({
        receiverId: id,
        patientName: name,
        contactNum: number,
        reason: reason,
        bloodGroup: bloodGroup,
        hospitalAddress: hospitalName
        });
        _requestId[id].push(_request);
        request.push(_request);
    }

    function getReceiver(string memory receiverId)public view returns(UserStruct memory){
        uint _receiver = _receiverId[receiverId];
        return receiver[_receiver];
    }

    function getDonor(string memory donorId)public view returns(UserStruct memory){
        uint _donor = _donorId[donorId];
        return donor[_donor];
    }

    function setAvaibility(string memory donorId)public{
        uint index = availableDonors.length;
        availableDonors.push(getDonor(donorId));
        _avaibilityId[donorId] = index;
    }

    function removeAvailbility(string memory donorId)public{
        uint lastIndex = availableDonors.length-1;
        uint removeElement = _avaibilityId[donorId];
        availableDonors[removeElement] = availableDonors[lastIndex];
        _avaibilityId[availableDonors[lastIndex].id] = _avaibilityId[donorId];
        availableDonors.pop();
    }

    function getUserRequests(string memory id)public view returns(Request [] memory){
        return _requestId[id];
    }

    function getAllRequest()public view returns(Request [] memory){
        return request;
    }

    function getAllDonors()public view returns(UserStruct [] memory){
        return donor;
    }

    function getAvailableDonors()public view returns(UserStruct [] memory){
        return availableDonors;
    }


}