import 'dart:io';

class Book {
  String title;
  String author;
  String isbn;
  int copies;

  Book({required this.title, required this.author, required this.isbn, required this.copies});

  void borrow() {
    if (copies > 0) {
      copies--;
      print('Book borrowed: $title');
    } else {
      print('No copies left for $title');
    }
  }

  void returnBook() {
    copies++;
    print('Book returned: $title');
  }

  @override
  String toString() {
    return '$title by $author (ISBN: $isbn, Copies: $copies)';
  }
}

class Member {
  String name;
  String memberId;
  List<Book> borrowedBooks;

  Member({required this.name, required this.memberId}) : borrowedBooks = [];

  void borrow(Book book) {
    if (!borrowedBooks.contains(book)) {
      if (book.copies > 0) {
        book.borrow();
        borrowedBooks.add(book);
        print('Book added to borrowed list: ${book.title}');
      } else {
        print('No copies left to borrow: ${book.title}');
      }
    } else {
      print('You already borrowed this book');
    }
  }

  void returnBook(Book book) {
    if (borrowedBooks.contains(book)) {
      book.returnBook();
      borrowedBooks.remove(book);
      print('Book removed from borrowed list: ${book.title}');
    } else {
      print('You did not borrow this book');
    }
  }

  @override
  String toString() {
    return 'Member: $name, ID: $memberId';
  }
}

class Library {
  List<Book> books = [];
  List<Member> members = [];

  void addBook(Book book) {
    books.add(book);
    print('Book added: ${book.title}');
    print('------------');
  }

  void removeBook(String isbn) {
    books.removeWhere((book) => book.isbn == isbn);
    print('Book removed with ISBN: $isbn');
    print('------------');
  }

  void registerMember(Member member) {
    members.add(member);
    print('Member registered: ${member.name}');
    print('------------');
  }

  void borrowBook(String memberId, String isbn) {
    var member = members.firstWhere((m) => m.memberId == memberId, orElse: () => Member(name: 'Unknown', memberId: ''));
    var book = books.firstWhere((b) => b.isbn == isbn, orElse: () => Book(title: 'Unknown', author: 'Unknown', isbn: '', copies: 0));

    if (member.memberId != 'Unknown' && book.isbn != '') {
      member.borrow(book);
    } else {
      if (member.memberId == 'Unknown') {
        print('Member not found');
      }
      if (book.isbn == '') {
        print('Book not found');
      }
    }
    print('------------');
  }

  void returnBook(String memberId, String isbn) {
    var member = members.firstWhere((m) => m.memberId == memberId, orElse: () => Member(name: 'Unknown', memberId: ''));
    var book = books.firstWhere((b) => b.isbn == isbn, orElse: () => Book(title: 'Unknown', author: 'Unknown', isbn: '', copies: 0));

    if (member.memberId != 'Unknown' && book.isbn != '') {
      member.returnBook(book);
    } else {
      if (member.memberId == 'Unknown') {
        print('Member not found');
      }
      if (book.isbn == '') {
        print('Book not found');
      }
    }
    print('------------');
  }

  void displayBooks() {
    print('Books in Library:');
    for (var book in books) {
      print(book);
    }
    print('------------');
  }

  void displayMembers() {
    print('Members in Library:');
    for (var member in members) {
      print(member);
    }
    print('------------');
  }
}

void main() {
  var library = Library();

  while (true) {
    print('\nLibrary Menu');
    print('1. Add book');
    print('2. Remove book');
    print('3. Register member');
    print('4. Borrow book');
    print('5. Return book');
    print('6. Display books');
    print('7. Display members');
    print('8. Exit');
    print('Please Select Choice:');

    var choice = stdin.readLineSync() ?? '';
    print('------------');

    switch (choice) {
      case '1':
        print('Enter book title:');
        var title = stdin.readLineSync() ?? '';
        print('Enter book author:');
        var author = stdin.readLineSync() ?? '';
        var isbn = '';
        while (true) {
          print('Enter book ISBN:');
          isbn = stdin.readLineSync() ?? '';
          if (RegExp(r'^\d+$').hasMatch(isbn)) {
            break;
          } else {
            print('Only numbers are allowed for ISBN');
          }
        }
        var copies = 0;
        while (true) {
          print('Enter number of copies:');
          var copiesInput = stdin.readLineSync() ?? '';
          try {
            copies = int.parse(copiesInput);
            break;
          } catch (e) {
            print('Only numbers are allowed for copies');
          }
        }
        var newBook = Book(title: title, author: author, isbn: isbn, copies: copies);
        library.addBook(newBook);
        break;
      case '2':
        print('Enter book ISBN to remove:');
        var isbn = stdin.readLineSync() ?? '';
        library.removeBook(isbn);
        break;
      case '3':
        print('Enter member name:');
        var name = stdin.readLineSync() ?? '';
        print('Enter member ID:');
        var memberId = stdin.readLineSync() ?? '';
        var newMember = Member(name: name, memberId: memberId);
        library.registerMember(newMember);
        break;
      case '4':
        print('Enter member ID:');
        var memberId = stdin.readLineSync() ?? '';
        print('Enter book ISBN:');
        var isbn = stdin.readLineSync() ?? '';
        library.borrowBook(memberId, isbn);
        break;
      case '5':
        print('Enter member ID:');
        var memberId = stdin.readLineSync() ?? '';
        print('Enter book ISBN:');
        var isbn = stdin.readLineSync() ?? '';
        library.returnBook(memberId, isbn);
        break;
      case '6':
        library.displayBooks();
        break;
      case '7':
        library.displayMembers();
        break;
      case '8':
        exit(0);
      default:
        print('Invalid choice');
        print('------------');
    }
  }
}
