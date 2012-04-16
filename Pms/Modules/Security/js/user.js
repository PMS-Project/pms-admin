var users = {};

function loadUsers (){
  $.getJSON('module.pl?mod=Security;action=getUsers', function(data) {
    for(var i = 0; i < data.length; i++){
      
      users[data[i].id] = data[i]; 
      
      var $dropdownMenu = $('<div class="btn-group">');
      $dropdownMenu.append($('<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><i class="icon-user icon-white"></i>Optionen</a>'));
      
      var $menuList = $('<ul class="dropdown-menu">');
      
      var $editButton = $('<a href="#"><i class="icon-pencil"></i> Bearbeiten</a>');
      $editButton.click(on_EditUserClicked);
      var $deleteButton = $('<a href="#"><i class="icon-trash"></i> L&ouml;schen</a>');
      $deleteButton.click(on_DeleteUserClicked);
      
      $menuList.append($editButton);
      $menuList.append($deleteButton);
      
      $dropdownMenu.append($menuList);
      
      var $dropdownCol = $('<td/>');
      $dropdownCol.append($dropdownMenu);

      var $tableRow = $('<tr/>');
      $tableRow.attr('data-userid',data[i].id);
      $tableRow.append($('<td/>').html(data[i].id));
      $tableRow.append($('<td/>').html(data[i].name));
      $tableRow.append($('<td/>').html(data[i].firstName));
      $tableRow.append($('<td/>').html(data[i].nickName));      
      $tableRow.append($dropdownCol);
      
      $('#userTableBody').append($tableRow);
    }
  }).fail(function(jqXHR, textStatus, errorThrown){ 
    alert("Konnte nicht geladen werden: "+textStatus); 
  });
}

function on_EditUserClicked() {
  //use jquery closest to find table row that knows the id
  $('#userEditModal').modal('show');
}

function on_DeleteUserClicked(){
  //use jquery closest to find table row that knows the id
}

$(document).ready(function(){
  enableBlockUI();
  loadUsers();
});