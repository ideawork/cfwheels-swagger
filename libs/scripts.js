$(function () {
  $('#tab-container').idTabs();

  $('#model').change(function(e){
    $('#submitted').remove();
    $('#endpoint').submit();
  });

  $('#all').change(function(e){
    $('[name="operation"]').prop('checked', $(this).is(':checked'));
  });

  $('input[type="checkbox"]:not(#all)').change(function(e){
    $('#all').prop('checked', false);
  });

  window.swaggerUi = new SwaggerUi({
//      url: 'http://petstore.swagger.wordnik.com/v2/swagger.json',
//      url: '/api/v1/swagger.json',
    spec: spec,
    dom_id: 'swagger',
    supportedSubmitMethods: ['get', 'post', 'put', 'delete'],
    docExpansion: 'none',
    sorter: 'alpha',
    onComplete: function(swaggerApi, swaggerUi){
      log('Loaded SwaggerUI');
    },
    onFailure: function(data) {
      log('Unable to Load SwaggerUI');
    }
  });
  //window.swaggerUi.load();
});