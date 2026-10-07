/// Shared (read-only) anime list. Everything a user *does* with it
/// (favorites, posts, recent searches) is stored per account in Firestore.
class Anime {
  const Anime({
    required this.id,
    required this.title,
    required this.genres,
    required this.image,
  });

  final String id;
  final String title;
  final List<String> genres;
  final String image;

  String get genreLabel => genres.join(' · ');
}

const List<Anime> animeCatalog = [
  Anime(
    id: 'jjk',
    title: 'Jujutsu Kaisen',
    genres: ['Action', 'Dark Fantasy'],
    image: 'assets/images/jjk.jpg',
  ),
  Anime(
    id: 'bluelock',
    title: 'Blue Lock',
    genres: ['Sports'],
    image: 'assets/images/bluelock.jpg',
  ),
  Anime(
    id: 'rezero',
    title: 'Re:Zero',
    genres: ['Isekai', 'Drama'],
    image: 'assets/images/rezero.jpg',
  ),
  Anime(
    id: 'sao',
    title: 'Sword Art Online',
    genres: ['Action', 'Fantasy'],
    image: 'assets/images/sao.jpg',
  ),
  Anime(
    id: 'slime',
    title: 'That Time I Got Reincarnated as a Slime',
    genres: ['Isekai', 'Fantasy'],
    image: 'assets/images/slime.jpg',
  ),
  Anime(
    id: 'akame',
    title: 'Akame ga Kill!',
    genres: ['Action', 'Dark Fantasy'],
    image: 'assets/images/akame.jpg',
  ),
  Anime(
    id: 'onepiece',
    title: 'One Piece',
    genres: ['Adventure'],
    image: 'assets/images/onepiece.jpg',
  ),
];

Anime? animeById(String? id) {
  if (id == null) return null;
  for (final a in animeCatalog) {
    if (a.id == id) return a;
  }
  return null;
}

/// All distinct genres, sorted, for the filter chips.
List<String> get allGenres {
  final set = <String>{};
  for (final a in animeCatalog) {
    set.addAll(a.genres);
  }
  return set.toList()..sort();
}

/// Images that can be picked as a profile picture.
const List<String> avatarChoices = [
  'assets/images/profile1.jpg',
  'assets/images/profile2.jpg',
  'assets/images/profile3.jpg',
  'assets/images/akame.jpg',
  'assets/images/jjk.jpg',
  'assets/images/bluelock.jpg',
  'assets/images/rezero.jpg',
  'assets/images/slime.jpg',
];
