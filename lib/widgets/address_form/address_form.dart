import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';
import 'package:user_structure/user_structure.dart';

class AddressForm<LocalityService extends LocalityServicePattern> extends StatefulWidget {
  final LocalityService localityService;
  final ValuesProvider valuesProvider;

  AddressForm({
    @required this.localityService,
    @required this.valuesProvider
  });

  @override
  State<StatefulWidget> createState() => _AddressFormState();
}

class _AddressFormState<LocalityService extends LocalityServicePattern> extends State<AddressForm> {
  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [
      SimpleTextField(
        fieldName: 'contact', 
        title: 'Contato', 
        textCapitalization: TextCapitalization.words,
        validators: [RequiredValidator()],),
      SimpleTextField(
        fieldName: 'zip_code', 
        title: 'CEP', 
        keyboardType: TextInputType.number, 
        inputFormatters: [SimpleFormatter('00000-000')], 
        validators: [RequiredValidator()],
        onChange: (value) => loadCity(context, value),),
      SimpleTextField(
        fieldName: 'street', 
        title: 'Endereço', 
        textCapitalization: TextCapitalization.words,
        validators: [RequiredValidator()],),
      SimpleTextField(
        fieldName: 'number', 
        title: 'Número', 
        validators: [RequiredValidator()],),
      SimpleTextField(
        fieldName: 'complement', 
        title: 'Complemento',),
      SimpleTextField(
        fieldName: 'neighborhood', 
        title: 'Bairro', 
        textCapitalization: TextCapitalization.words,
        validators: [RequiredValidator()],),
      SimpleTextField(
        fieldName: 'city_name', 
        title: 'Cidade', 
        validators: [RequiredValidator()],
        enabled: false,),
      SimpleTextField(
        fieldName: 'state', 
        title: 'Estado', 
        validators: [RequiredValidator()],
        enabled: false,),
    ];

    if (widget.valuesProvider['primary'] != null && widget.valuesProvider['primary'] != true) {
      fields.add(SimpleCheckField(
        fieldName: 'primary', 
        title: 'Definir este endereço como principal', 
        validators: [RequiredValidator()]));
    }

    return Column(
      children: fields
    );
  }

  loadCity(BuildContext context, String zipCode) async {
    if (zipCode != null && zipCode.replaceAll('.', '').replaceAll('-', '').replaceAll('_', '').length == 8) {
      await Dialogs.showAwait<CityModel>(context, 'Consultando cidade', () async {
        
        CityModel city = await widget.localityService.getCity('BRA', zipCode);
        if (city != null) {
          if (city.street != null && city.street.isNotEmpty) {
            widget.valuesProvider.setValue('street', city.street);
          }
          // if (city.complement != null && city.complement.isNotEmpty) {
          //   widget.valuesProvider.setValue('complement', city.complement);
          // }
          if (city.neighborhood != null && city.neighborhood.isNotEmpty) {
            widget.valuesProvider.setValue('neighborhood', city.neighborhood);
          }
          widget.valuesProvider.setValue('city_code', city.code);
          widget.valuesProvider.setValue('city_name', city.name);
          widget.valuesProvider.setValue('state', city.state);
        }
        return city;

      })
        .then((city) {
          if (city != null) {
            setState(() {});
          }
        });
    }
  }
}