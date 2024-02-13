import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _addContact();
          },
          child: Text('Add Contact'),
        ),
      ),
    );
  }

  void _addContact() async {
    // Request permission
    if (await Permission.contacts.request().isGranted) {
      // Permission to access contacts is granted

      // Create a new contact
      Contact newContact = Contact(
        givenName: 'Huy', // Specify the given name
        familyName: 'Kaiser',  // Specify the family name
        phones: [Item(label: 'mobile', value: '+123456789')],  // Specify phone number
      );

      // Save the new contact
      await ContactsService.addContact(newContact);

      // Show a message or navigate to another screen after successful addition
      print('Contact added successfully');
    } else {
      // Permission denied
      // Handle accordingly
      print('Permission to access contacts denied');
    }
  }

  Future<void> getAllContacts() async {
    try {
      // Retrieve all contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();

      // Print or use the retrieved contacts
      for (var contact in contacts) {
        print('Identifier: ${contact.identifier}');
        print('Family Name: ${contact.familyName}');
        print('Name: ${contact.displayName}');
        print('Phones: ${contact.phones}');
        print('Emails: ${contact.emails}');
        print('---');
      }
    } catch (e) {
      print('Error retrieving contacts: $e');
    }
  }

  Future<void> updateContact(String familyName, String phone) async {
    // Retrieve all contacts
    Iterable<Contact> contacts = await ContactsService.getContacts();

    // Find the contact to update (you might want to search by other criteria)
    Contact? contactToUpdate;
    for (var contact in contacts) {
      String? mobilePhone = contact.phones![0].value; // two types: mobile and work phone.

      if (contact.familyName == familyName &&  mobilePhone == phone) {
        contactToUpdate = contact;
        break;
      }
    }

    if (contactToUpdate != null) {
      // Update the contact details
      contactToUpdate.familyName = familyName + ":Updated";
      contactToUpdate.phones = [Item(label: 'mobile', value: phone.toString())];
      // contactToUpdate.emails = [Item(label: 'work', value: email)];

      // Save the updated contact
      await ContactsService.updateContact(contactToUpdate);
      print('Contact updated successfully');
    } else {
      print('Contact not found');
    }
  }
}