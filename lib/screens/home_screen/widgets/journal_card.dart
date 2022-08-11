import 'package:flutter/material.dart';
import 'package:flutter_webapi_second_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_second_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';
import '../../../helpers/weekday.dart';
import '../../../models/journal.dart';
import '../../add_journal_screen/add_journal_screen.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final String userId;
  const JournalCard(
      {Key? key,
      this.journal,
      required this.showedDate,
      required this.refreshFunction,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteJournal(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal internalJournal = Journal(
      id: const Uuid().v1(),
      content: "",
      createdAt: showedDate,
      updatedAt: showedDate,
      userId: userId,
    );

    if (journal != null) {
      internalJournal = journal;
    }

    Map<String, dynamic> map = {
      'journal': internalJournal,
      'is_editing': journal != null
    };

    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: map,
    ).then((value) {
      refreshFunction();

      if (value == DisposeStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro salvo com sucesso."),
          ),
        );
      } else if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha ao registar."),
          ),
        );
      }
    });
  }

  deleteJournal(BuildContext context) {
    showConfirmationDialog(
      context,
      content:
          "Deseja realmente remover o registro de ${WeekDay(journal!.createdAt)}?",
      affirmativeOption: "Remover",
    ).then((value) {
      if (value != null && value) {
        JournalService service = JournalService();
        if (journal != null) {
          service.remove(journal!.id).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text((value)
                    ? "Removido com sucesso!"
                    : "Houve um erro ao remover")));
          }).then((value) {
            refreshFunction();
          });
        }
      }
    });
  }
}
