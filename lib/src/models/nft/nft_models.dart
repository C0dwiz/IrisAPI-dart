class NftQuery {
  final int id;
  final String name;

  NftQuery({
    required this.id,
    required this.name,
  });

  Map<String, String> toParams() {
    return {
      'id': id.toString(),
      'name': name,
    };
  }
}

class NftGiveRequest extends NftQuery {
  final int userId;
  final String comment;

  NftGiveRequest({
    required super.id,
    required super.name,
    required this.userId,
    this.comment = '',
  });

  @override
  Map<String, String> toParams() {
    return {
      ...super.toParams(),
      'user_id': userId.toString(),
      'comment': comment,
    };
  }
}

class NftListRequest {
  final int offset;
  final int limit;

  NftListRequest({
    required this.offset,
    required this.limit,
  });

  Map<String, String> toParams() {
    return {
      'offset': offset.toString(),
      'limit': limit.toString(),
    };
  }
}

class NftTrait {
  final String emoji;
  final String customEmojiId;
  final String name;
  final int id;
  final int rarityPerMile;

  NftTrait({
    required this.emoji,
    required this.customEmojiId,
    required this.name,
    required this.id,
    required this.rarityPerMile,
  });

  factory NftTrait.fromJson(Map<String, dynamic> json) {
    return NftTrait(
      emoji: json['emoji']?.toString() ?? '',
      customEmojiId: json['custom_emoji_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      id: json['id'] is int ? json['id'] as int : 0,
      rarityPerMile:
          json['rarity_per_mile'] is int ? json['rarity_per_mile'] as int : 0,
    );
  }
}

class NftItem {
  final int id;
  final int number;
  final String urlName;
  final int ownerId;
  final String name;
  final int dateAdd;
  final NftTrait symbol;
  final NftTrait background;
  final NftTrait model;

  NftItem({
    required this.id,
    required this.number,
    required this.urlName,
    required this.ownerId,
    required this.name,
    required this.dateAdd,
    required this.symbol,
    required this.background,
    required this.model,
  });

  factory NftItem.fromJson(Map<String, dynamic> json) {
    return NftItem(
      id: json['id'] is int ? json['id'] as int : 0,
      number: json['number'] is int ? json['number'] as int : 0,
      urlName: json['url_name']?.toString() ?? '',
      ownerId: json['owner_id'] is int ? json['owner_id'] as int : 0,
      name: json['name']?.toString() ?? '',
      dateAdd: json['date_add'] is int ? json['date_add'] as int : 0,
      symbol: NftTrait.fromJson(
        (json['symbol'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      background: NftTrait.fromJson(
        (json['background'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      model: NftTrait.fromJson(
        (json['model'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
    );
  }
}

class NftHistoryEntry {
  final int date;
  final int nftId;
  final int id;
  final String type;
  final int peerId;

  NftHistoryEntry({
    required this.date,
    required this.nftId,
    required this.id,
    required this.type,
    required this.peerId,
  });

  factory NftHistoryEntry.fromJson(Map<String, dynamic> json) {
    return NftHistoryEntry(
      date: json['date'] is int ? json['date'] as int : 0,
      nftId: json['nft_id'] is int ? json['nft_id'] as int : 0,
      id: json['id'] is int ? json['id'] as int : 0,
      type: json['type']?.toString() ?? '',
      peerId: json['peer_id'] is int ? json['peer_id'] as int : 0,
    );
  }
}
