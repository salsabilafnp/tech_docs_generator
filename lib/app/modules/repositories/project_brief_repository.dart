import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';

class ProjectBriefRepository {
  static final ProjectBriefRepository instance = ProjectBriefRepository._init();
  static Database? _database;
  ProjectBriefRepository._init();

  static const String _tableName = 'project_briefs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('main_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // create database table
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const nullableTextType = 'TEXT';

    await db.execute('''
      CREATE TABLE $_tableName (
        id $idType,
        projectTitle $textType,
        docVersion $textType,
        author $textType,
        problem $textType,
        vision $textType,
        targetUser $textType,
        
        -- Kolom untuk menyimpan JSON String dari List
        coreFeatures $textType,
        userScenario $textType,
        techTools $textType,

        -- Kolom untuk path gambar dan link
        uiDesignImagePath $nullableTextType,
        uiDesignLink $textType,
        architectureImagePath $nullableTextType,
        architectureLink $nullableTextType
      )
    ''');
  }

  // CREATE
  Future<ProjectBrief> create(ProjectBrief brief) async {
    final db = await instance.database;
    final map = brief.toMap();

    map.remove('id');
    final id = await db.insert(_tableName, map);

    return brief.copyWith(id: id);
  }

  // READ (ALL)
  Future<List<ProjectBrief>> fetchAll() async {
    final db = await instance.database;
    const orderBy = 'id DESC';
    final result = await db.query(_tableName, orderBy: orderBy);
    return result.map((json) => ProjectBrief.fromMap(json)).toList();
  }

  // (Helper) READ (Single)
  Future<ProjectBrief> readBrief(int id) async {
    final db = await instance.database;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ProjectBrief.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // UPDATE
  Future<int> update(ProjectBrief brief) async {
    final db = await instance.database;
    return db.update(
      _tableName,
      brief.toMap(),
      where: 'id = ?',
      whereArgs: [brief.id],
    );
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // DUPLICATE
  Future<ProjectBrief> duplicate(int id) async {
    final existingBrief = await readBrief(id);
    final duplicatedBrief = existingBrief.copyWith(
      id: null,
      projectTitle: '${existingBrief.projectTitle} - Copy',
    );
    return await create(duplicatedBrief);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
