var channels = {};
var currentChannel = null;
var $currentEditRow = null;

function loadChannels (){
  $.getJSON('module.pl?mod=Security;action=getChannels', function(data) {
    for(var i = 0; i < data.length; i++){
      channels[data[i].id] = data[i]; 
      addChannelToTable(data[i]);
    }
  }).fail(function(jqXHR, textStatus, errorThrown){ 
    alert("Konnte nicht geladen werden: "+textStatus); 
  });
}

function addChannelToTable (lChannel){
      var $dropdownMenu = $('<div class="btn-group">');
      
      var $editButton = $('<a class="btn btn-primary" href="#"><i class="icon-pencil icon-white"></i> Bearbeiten</a>');
      $editButton.click(on_EditChannelClicked);
      
      $dropdownMenu.append($editButton);
      $dropdownMenu.append($('<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>'));
      
      
      var $deleteButton = $('<a href="#"><i class="icon-trash"></i> L&ouml;schen</a>');
      $deleteButton.click(on_DeleteChannelClicked);
      
      var $menuList = $('<ul class="dropdown-menu">');
      $menuList.append($deleteButton);
      
      $dropdownMenu.append($menuList);
      
      var $dropdownCol = $('<td/>');
      $dropdownCol.append($dropdownMenu);

      var $tableRow = $('<tr/>');
      $tableRow.attr('data-channelid',lChannel.id);
      $tableRow.append($('<td/>').html(lChannel.id));
      $tableRow.append($('<td/>').html(lChannel.name));
      $tableRow.append($('<td/>').html(lChannel.topic));   
      $tableRow.append($dropdownCol);
      
      $('#channelTableBody').append($tableRow);  
}

function editChannel (channel){
  currentChannel = channel;
  $('#inputChannelName').val(channel.name);
  $('#inputChannelTopic').val(channel.topic);
  $('#channelEditModal').modal('show');  
}

function on_EditChannelClicked( ) {
  //use jquery closest to find table row that knows the id
  $currentEditRow  = $(this).closest('tr');
  var channelId = $currentEditRow.attr('data-channelid');

  if(channelId === undefined)
    return;
  
  if(channels[channelId] === undefined){
    alert("Unknown Channel ID");
    return;
  }
  editChannel(channels[channelId]);
}

function on_AddChannelClicked( ) {
  $currentEditRow  = null;
  var newChannel = {
    id        : -1,
    name      : "",
    topic     : ""
  };
  
  editChannel(newChannel);
}

function on_DeleteChannelClicked(){
  //use jquery closest to find table row that knows the id
  
  if (!confirm("M&ouml;chten Sie den Channel wirklich l&ouml;schen?\nDiese Aktion kann man nicht r&uuml;ckg&auml;ngig machen.")) {
                return;
  }
  
  $currentEditRow  = $(this).closest('tr');
  var channelId = $currentEditRow.attr('data-channelid');
  
  var jsonData = jsonData =JSON.stringify({ id : channelId});
  
  $.postJSON('module.pl?mod=Security;action=delChannel',jsonData,function(data){
    if(data.result == false){
      alert("Channel konnte nicht gelöscht werden: "+data.error);
    }else{
      $currentEditRow.slideUp("normal",function(){$currentEditRow.remove(); $currentEditRow = null;});
    }
  }).fail(function(jqXHR, textStatus, errorThrown){ 
    var message = textStatus;
    alert("Channel konnte nicht gelöscht werden: "+message);
  }); //ajax  
}

function on_CancelEditChannelClicked(){
  $('#channelEditModal').modal('hide');
}

function on_SaveEditChannelClicked(){
  var obj = {};
  obj.id = currentChannel.id;
  obj.name  = $('#inputChannelName').val();
  obj.topic = $('#inputChannelTopic').val();
  
  var jsonData =JSON.stringify(obj);
  
  $.postJSON('module.pl?mod=Security;action=saveChannel',jsonData,function(data){
    if(data.result == false){
      alert("Channel konnte nicht gespeichert werden: "+data.error);
    }else{
      var isNewChannel = (obj.id == -1);
      obj.id = data.id;
      channels[obj.id] = obj;
      
      if(isNewChannel){
        addChannelToTable(obj);
      }else{
        //write data into table
        var $rows = $currentEditRow.children('td');
        $($rows[0]).html(obj.id);
        $($rows[1]).html(obj.name);
        $($rows[2]).html(obj.topic);
      }
      $('#channelEditModal').modal('hide');
    }
  }).fail(function(jqXHR, textStatus, errorThrown){ 
    var message = textStatus;
    alert("Channel konnte nicht gespeichert werden: "+message);
  });
}

$(document).ready(function(){
  enableBlockUI();
  $('#channelEditCancel').click(on_CancelEditChannelClicked);
  $('#channelEditOk').click(on_SaveEditChannelClicked);
  $('#addChannelButton').click(on_AddChannelClicked);
  loadChannels();
});