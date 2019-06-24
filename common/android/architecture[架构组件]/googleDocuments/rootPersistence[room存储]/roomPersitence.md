Room Persistence Library   **Part of Android Jetpack.**

The [Room](https://developer.android.com/training/data-storage/room/index.html) persistence library provides an abstraction layer over SQLite to allow for more robust database access while harnessing the full power of SQLite.

The library helps you create a cache of your app's data on a device that's running your app. This cache, which serves as your app's single source of truth, allows users to view a consistent copy of key information within your app, regardless of whether users have an internet connection.

**Note:** To import Room into your Android project, see the [room release notes](https://developer.android.com/jetpack/androidx/releases/room).

Further documentation

For a guide on applying Room's capabilities to your app's data storage persistence solution, see the [Room](https://developer.android.com/training/data-storage/room/index.html)training guide.

Additional resources

To learn more about Room, consult the following additional resources.

Samples

- [Sunflower](https://github.com/googlesamples/android-sunflower), a gardening app illustrating Android development best practices with Android Jetpack.
- [Room migration sample](https://github.com/googlesamples/android-architecture-components/tree/master/PersistenceMigrationsSample)
- Room & RxJava Sample [(Java)](https://github.com/googlesamples/android-architecture-components/tree/master/BasicRxJavaSample) [(Kotlin)](https://github.com/googlesamples/android-architecture-components/tree/master/BasicRxJavaSampleKotlin)

Codelabs

- Android Room with a View [(Java)](https://codelabs.developers.google.com/codelabs/android-room-with-a-view) [(Kotlin)](https://codelabs.developers.google.com/codelabs/android-room-with-a-view-kotlin)
- [Android Persistence codelab](https://codelabs.developers.google.com/codelabs/android-persistence/index.html?index=..%2F..%2Findex#0)

Blogs

- [Introducing Android Sunflower](https://medium.com/androiddevelopers/introducing-android-sunflower-e421b43fe0c2)
- [Room + Time](https://medium.com/androiddevelopers/room-time-2b4cf9672b98?source=false---------7)
- [Incrementally migrate from SQLite to Room](https://medium.com/androiddevelopers/incrementally-migrate-from-sqlite-to-room-66c2f655b377)
- [7 Pro-tips for Room](https://medium.com/androiddevelopers/7-pro-tips-for-room-fbadea4bfbd1)
- [Understanding migrations with Room](https://medium.com/androiddevelopers/understanding-migrations-with-room-f01e04b07929)
- [Testing Room migrations](https://medium.com/androiddevelopers/testing-room-migrations-be93cdb0d975)
- [Room + RxJava](https://medium.com/androiddevelopers/room-rxjava-acb0cd4f3757)



Save data in a local database using Room

Room provides an abstraction layer over SQLite to allow fluent database access while harnessing the full power of SQLite.

Apps that handle non-trivial amounts of structured data can benefit greatly from persisting that data locally. The most common use case is to cache relevant pieces of data. That way, when the device cannot access the network, the user can still browse that content while they are offline. Any user-initiated content changes are then synced to the server after the device is back online.

Because Room takes care of these concerns for you, we **highly recommend** using Room instead of SQLite. However, if you prefer to use SQLite APIs directly, read [Save Data Using SQLite](https://developer.android.com/training/data-storage/sqlite.html).

**Note:** In order to use Room in your app, [add the Architecture Components](https://developer.android.com/topic/libraries/architecture/adding-components.html#room) artifacts to your app's `build.gradle` file.

There are 3 major components in Room:

- [**Database:**](https://developer.android.com/reference/androidx/room/Database.html) Contains the database holder and serves as the main access point for the underlying connection to your app's persisted, relational data.

  The class that's annotated with [`@Database`](https://developer.android.com/reference/androidx/room/Database.html) should satisfy the following conditions:

  - Be an abstract class that extends [`RoomDatabase`](https://developer.android.com/reference/androidx/room/RoomDatabase.html).
  - Include the list of entities associated with the database within the annotation.
  - Contain an abstract method that has 0 arguments and returns the class that is annotated with [`@Dao`](https://developer.android.com/reference/androidx/room/Dao.html).

  At runtime, you can acquire an instance of [`Database`](https://developer.android.com/reference/androidx/room/Database.html) by calling [`Room.databaseBuilder()`](https://developer.android.com/reference/androidx/room/Room.html#databaseBuilder(android.content.Context, java.lang.Class, java.lang.String)) or[`Room.inMemoryDatabaseBuilder()`](https://developer.android.com/reference/androidx/room/Room.html#inMemoryDatabaseBuilder(android.content.Context, java.lang.Class)).

  

- [**Entity:**](https://developer.android.com/training/data-storage/room/defining-data.html) Represents a table within the database.

- [**DAO:**](https://developer.android.com/training/data-storage/room/accessing-data.html) Contains the methods used for accessing the database.

The app uses the Room database to get the data access objects, or DAOs, associated with that database. The app then uses each DAO to get entities from the database and save any changes to those entities back to the database. Finally, the app uses an entity to get and set values that correspond to table columns within the database.

This relationship among the different components of Room appears in Figure 1:

![img](files/room_architecture.png)**Figure 1.** Room architecture diagram

The following code snippet contains a sample database configuration with one entity and one DAO:

User

[KOTLIN](https://developer.android.com/training/data-storage/room/index.html#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/index.html#java)

```java
@Entity
public class User {
    @PrimaryKey
    public int uid;

    @ColumnInfo(name = "first_name")
    public String firstName;

    @ColumnInfo(name = "last_name")
    public String lastName;
}
```



UserDao

[KOTLIN](https://developer.android.com/training/data-storage/room/index.html#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/index.html#java)

```java
@Dao
public interface UserDao {
    @Query("SELECT * FROM user")
    List<User> getAll();

    @Query("SELECT * FROM user WHERE uid IN (:userIds)")
    List<User> loadAllByIds(int[] userIds);

    @Query("SELECT * FROM user WHERE first_name LIKE :first AND " +
           "last_name LIKE :last LIMIT 1")
    User findByName(String first, String last);

    @Insert
    void insertAll(User... users);

    @Delete
    void delete(User user);
}
```



AppDatabase

[KOTLIN](https://developer.android.com/training/data-storage/room/index.html#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/index.html#java)

```java
@Database(entities = {User.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {
    public abstract UserDao userDao();
}
```



After creating the files above, you get an instance of the created database using the following code:

[KOTLIN](https://developer.android.com/training/data-storage/room/index.html#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/index.html#java)

```java
AppDatabase db = Room.databaseBuilder(getApplicationContext(),
        AppDatabase.class, "database-name").build();
```



**Note:** If your app runs in a single process, you should follow the singleton design pattern when instantiating an `AppDatabase` object. Each [`RoomDatabase`](https://developer.android.com/reference/androidx/room/RoomDatabase.html) instance is fairly expensive, and you rarely need access to multiple instances within a single process.

If your app runs in multiple processes, include `enableMultiInstanceInvalidation()` in your database builder invocation. That way, when you have an instance of `AppDatabase` in each process, you can invalidate the shared database file in one process, and this invalidation automatically propagates to the instances of `AppDatabase` within other processes.

For a hands-on experience with Room, try the [Android Room with a View](https://codelabs.developers.google.com/codelabs/android-room-with-a-view-kotlin) and [Android Persistence](https://codelabs.developers.google.com/codelabs/android-persistence/) codelabs. To browse Room code samples, see the [Android Architecture Components samples](https://github.com/googlesamples/android-architecture-components/).



Defining data using Room entities

When using the [Room persistence library](https://developer.android.com/training/data-storage/room/index.html), you define sets of related fields as *entities*. For each entity, a table is created within the associated [`Database`](https://developer.android.com/reference/androidx/room/Database.html) object to hold the items. You must reference the entity class through the[`entities`](https://developer.android.com/reference/androidx/room/Database.html#entities()) array in the [`Database`](https://developer.android.com/reference/androidx/room/Database.html) class.

**Note:** To use entities in your app, [add the Architecture Components artifacts](https://developer.android.com/topic/libraries/architecture/adding-components.html) to your app's `build.gradle` file.

The following code snippet shows how to define an entity:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity
public class User {
    @PrimaryKey
    public int id;

    public String firstName;
    public String lastName;
}
```



To persist a field, Room must have access to it. You can make a field public, or you can provide a getter and setter for it. If you use getter and setter methods, keep in mind that they're based on JavaBeans conventions in Room.

**Note:** Entities can have either an empty constructor (if the corresponding [DAO](https://developer.android.com/training/data-storage/room/accessing-data.html) class can access each persisted field) or a constructor whose parameters contain types and names that match those of the fields in the entity. Room can also use full or partial constructors, such as a constructor that receives only some of the fields.

Use a primary key

Each entity must define at least 1 field as a primary key. Even when there is only 1 field, you still need to annotate the field with the [`@PrimaryKey`](https://developer.android.com/reference/androidx/room/PrimaryKey.html) annotation. Also, if you want Room to assign automatic IDs to entities, you can set the `@PrimaryKey`'s [`autoGenerate`](https://developer.android.com/reference/androidx/room/PrimaryKey.html#autoGenerate()) property. If the entity has a composite primary key, you can use the[`primaryKeys`](https://developer.android.com/reference/androidx/room/Entity.html#primaryKeys()) property of the [`@Entity`](https://developer.android.com/reference/androidx/room/Entity.html) annotation, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(primaryKeys = {"firstName", "lastName"})
public class User {
    public String firstName;
    public String lastName;
}
```



By default, Room uses the class name as the database table name. If you want the table to have a different name, set the [`tableName`](https://developer.android.com/reference/androidx/room/Entity.html#tableName()) property of the [`@Entity`](https://developer.android.com/reference/androidx/room/Entity.html) annotation, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(tableName = "users")
public class User {
    // ...
}
```



**Caution:** Table names in SQLite are case-insensitive.

Similar to the [`tableName`](https://developer.android.com/reference/androidx/room/Entity.html#tableName()) property, Room uses the field names as the column names in the database. If you want a column to have a different name, add the [`@ColumnInfo`](https://developer.android.com/reference/androidx/room/ColumnInfo.html) annotation to a field, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(tableName = "users")
public class User {
    @PrimaryKey
    public int id;

    @ColumnInfo(name = "first_name")
    public String firstName;

    @ColumnInfo(name = "last_name")
    public String lastName;
}
```





Ignore fields

By default, Room creates a column for each field that's defined in the entity. If an entity has fields that you don't want to persist, you can annotate them using [`@Ignore`](https://developer.android.com/reference/androidx/room/Ignore.html), as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity
public class User {
    @PrimaryKey
    public int id;

    public String firstName;
    public String lastName;

    @Ignore
    Bitmap picture;
}
```



In cases where an entity inherits fields from a parent entity, it's usually easier to use the [`ignoredColumns`](https://developer.android.com/reference/androidx/room/Entity#ignoredcolumns) property of the `@Entity` attribute:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(ignoredColumns = "picture")
public class RemoteUser extends User {
    @PrimaryKey
    public int id;

    public boolean hasVpn;
}
```



Provide table search support

Room supports several types of annotations that make it easier for you to search for details in your database's tables. Use full-text search unless your app's `minSdkVersion` is less than 16.

Support full-text search

If your app requires very quick access to database information through full-text search (FTS), have your entities backed by a virtual table that uses either the FTS3 or FTS4 [SQLite extension module](https://www.sqlite.org/fts3.html). To use this capability, available in Room 2.1.0 and higher, add the [`@Fts3`](https://developer.android.com/reference/androidx/room/Fts3) or [`@Fts4`](https://developer.android.com/reference/androidx/room/Fts4) annotation to a given entity, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
// Use `@Fts3` only if your app has strict disk space requirements or if you
// require compatibility with an older SQLite version.
@Fts4
@Entity(tableName = "users")
public class User {
    // Specifying a primary key for an FTS-table-backed entity is optional, but
    // if you include one, it must use this type and column name.
    @PrimaryKey
    @ColumnInfo(name = "rowid")
    public int id;

    @ColumnInfo(name = "first_name")
    public String firstName;
}
```



**Note:** FTS-enabled tables always use a primary key of type `INTEGER` and with the column name "rowid". If your FTS-table-backed entity defines a primary key, it **must** use that type and column name.

In cases where a table supports content in multiple languages, use the `languageId` option to specify the column that stores language information for each row:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Fts4(languageId = "lid")
@Entity(tableName = "users")
public class User {
    // ...

    @ColumnInfo(name = "lid")
    int languageId;
}
```



Room provides several other options for defining FTS-backed entities, including result ordering, tokenizer types, and tables managed as external content. For more details about these options, see the [`FtsOptions`](https://developer.android.com/reference/androidx/room/FtsOptions)reference.

Index specific columns

If your app must support SDK versions that don't allow for using FTS3- or FTS4-table-backed entities, you can still index certain columns in the database to speed up your queries. To add indices to an entity, include the[`indices`](https://developer.android.com/reference/androidx/room/Entity.html#indices()) property within the [`@Entity`](https://developer.android.com/reference/androidx/room/Entity.html) annotation, listing the names of the columns that you want to include in the index or composite index. The following code snippet demonstrates this annotation process:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(indices = {@Index("name"),
        @Index(value = {"last_name", "address"})})
public class User {
    @PrimaryKey
    public int id;

    public String firstName;
    public String address;

    @ColumnInfo(name = "last_name")
    public String lastName;

    @Ignore
    Bitmap picture;
}
```



Sometimes, certain fields or groups of fields in a database must be unique. You can enforce this uniqueness property by setting the [`unique`](https://developer.android.com/reference/androidx/room/Index.html#unique()) property of an [`@Index`](https://developer.android.com/reference/androidx/room/Index.html) annotation to `true`. The following code sample prevents a table from having two rows that contain the same set of values for the `firstName` and `lastName` columns:

[KOTLIN](https://developer.android.com/training/data-storage/room/defining-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/defining-data#java)

```java
@Entity(indices = {@Index(value = {"first_name", "last_name"},
        unique = true)})
public class User {
    @PrimaryKey
    public int id;

    @ColumnInfo(name = "first_name")
    public String firstName;

    @ColumnInfo(name = "last_name")
    public String lastName;

    @Ignore
    Bitmap picture;
}
```



Include AutoValue-based objects

**Note:** This capability is designed for use only in Java-based entities. To achieve the same functionality in Kotlin-based entities, it's better to use [data classes](https://kotlinlang.org/docs/reference/data-classes.html) instead.

In Room 2.1.0 and higher, you can use Java-based [immutable value classes](https://github.com/google/auto/blob/master/value/userguide/index.md), which you annotate using `@AutoValue`, as entities in your app's database. This support is particularly helpful when two instances of an entity are considered to be equal if their columns contain identical values.

When using classes annotated with `@AutoValue` as entities, you can annotate the class's abstract methods using `@PrimaryKey`, `@ColumnInfo`, `@Embedded`, and `@Relation`. When using these annotations, however, you must include the `@CopyAnnotations` annotation each time so that Room can interpret the methods' auto-generated implementations properly.

The following code snippet shows an example of a class annotated with `@AutoValue` that Room recognizes as an entity:

User.java

```java
@AutoValue
@Entity
public abstract class User {
    // Supported annotations must include `@CopyAnnotations`.
    @CopyAnnotations
    @PrimaryKey
    public abstract long getId();

    public abstract String getFirstName();
    public abstract String getLastName();

    // Room uses this factory method to create User objects.
    public static User create(long id, String firstName, String lastName) {
        return new AutoValue_User(id, firstName, lastName);
    }
}
```



Define relationships between objects

Because SQLite is a relational database, you can specify relationships between objects. Even though most object-relational mapping libraries allow entity objects to reference each other, Room explicitly forbids this. To learn about the technical reasoning behind this decision, see [Understand why Room doesn't allow object references](https://developer.android.com/training/data-storage/room/referencing-data.html#understand-no-object-references).

Define one-to-many relationships

Even though you cannot use direct relationships, Room still allows you to define Foreign Key constraints between entities.

For example, if there's another entity called `Book`, you can define its relationship to the `User` entity using the[`@ForeignKey`](https://developer.android.com/reference/androidx/room/ForeignKey.html) annotation, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/relationships#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/relationships#java)

```java
@Entity(foreignKeys = @ForeignKey(entity = User.class,
                                  parentColumns = "id",
                                  childColumns = "user_id"))
public class Book {
    @PrimaryKey public int bookId;

    public String title;

    @ColumnInfo(name = "user_id") public int userId;
}
```



Since zero or more instances of `Book` can be linked to a single instance of `User` through the `user_id` foreign key, this models a one-to-many relationship between `User` and `Book`.

Foreign keys are very powerful, as they allow you to specify what occurs when the referenced entity is updated. For instance, you can tell SQLite to delete all books for a user if the corresponding instance of `User` is deleted by including [`onDelete = CASCADE`](https://developer.android.com/reference/androidx/room/ForeignKey.html#onDelete()) in the [`@ForeignKey`](https://developer.android.com/reference/androidx/room/ForeignKey.html) annotation.

**Note:** SQLite handles [`@Insert(onConflict = REPLACE)`](https://developer.android.com/reference/androidx/room/OnConflictStrategy.html#REPLACE) as a set of `REMOVE` and `REPLACE` operations instead of a single `UPDATE` operation. This method of replacing conflicting values could affect your foreign key constraints. For more details, see the [SQLite documentation](https://sqlite.org/lang_conflict.html) for the `ON_CONFLICT` clause.

Create nested objects

Sometimes, you'd like to express an entity or data object as a cohesive whole in your database logic, even if the object contains several fields. In these situations, you can use the [`@Embedded`](https://developer.android.com/reference/androidx/room/Embedded.html) annotation to represent an object that you'd like to decompose into its subfields within a table. You can then query the embedded fields just as you would for other individual columns.

For instance, your `User` class can include a field of type `Address`, which represents a composition of fields named `street`, `city`, `state`, and `postCode`. To store the composed columns separately in the table, include an`Address` field in the `User` class that is annotated with [`@Embedded`](https://developer.android.com/reference/androidx/room/Embedded.html), as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/relationships#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/relationships#java)

```java
public class Address {
    public String street;
    public String state;
    public String city;

    @ColumnInfo(name = "post_code") public int postCode;
}

@Entity
public class User {
    @PrimaryKey public int id;

    public String firstName;

    @Embedded public Address address;
}
```



The table representing a `User` object then contains columns with the following names: `id`, `firstName`, `street`, `state`, `city`, and `post_code`.

**Note:** Embedded fields can also include other embedded fields.

If an entity has multiple embedded fields of the same type, you can keep each column unique by setting the[`prefix`](https://developer.android.com/reference/androidx/room/Embedded.html#prefix()) property. Room then adds the provided value to the beginning of each column name in the embedded object.

Define many-to-many relationships

There is another kind of relationship which you often want to model in a relational database: a many-to-many relationship between two entities, where each entity can be linked to zero or more instances of the other. For instance, consider a music streaming app where users can organize their favorite songs into playlists. Each playlist can have any number of songs, and each song can be included in any number of playlists.

To model this relationship, you will need to create three objects:

1. An entity class for the playlists.
2. An entity class for the songs.
3. An intermediate class to hold the information about which songs are in each playlist.

You can define the entity classes as independent units:

[KOTLIN](https://developer.android.com/training/data-storage/room/relationships#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/relationships#java)

```java
@Entity
public class Playlist {
    @PrimaryKey public int id;

    public String name;
    public String description;
}

@Entity
public class Song {
    @PrimaryKey public int id;

    public String songName;
    public String artistName;
}
```



Then, define the intermediate class as an entity containing foreign key references to both `Song` and `Playlist`:

[KOTLIN](https://developer.android.com/training/data-storage/room/relationships#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/relationships#java)

```java
@Entity(tableName = "playlist_song_join",
        primaryKeys = { "playlistId", "songId" },
        foreignKeys = {
                @ForeignKey(entity = Playlist.class,
                            parentColumns = "id",
                            childColumns = "playlistId"),
                @ForeignKey(entity = Song.class,
                            parentColumns = "id",
                            childColumns = "songId")
                })
public class PlaylistSongJoin {
    public int playlistId;
    public int songId;
}
```



This produces a many-to-many relationship model that allows you to use a DAO to query both playlists by song and songs by playlist:

[KOTLIN](https://developer.android.com/training/data-storage/room/relationships#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/relationships#java)

```
@Daopublic interface PlaylistSongJoinDao {    @Insert    void insert(PlaylistSongJoin playlistSongJoin);    @Query("SELECT * FROM playlist " +           "INNER JOIN playlist_song_join " +           "ON playlist.id=playlist_song_join.playlistId " +           "WHERE playlist_song_join.songId=:songId")    List<Playlist> getPlaylistsForSong(final int songId);    @Query("SELECT * FROM song " +           "INNER JOIN playlist_song_join " +           "ON song.id=playlist_song_join.songId " +           "WHERE playlist_song_join.playlistId=:playlistId")    List<Song> getSongsForPlaylist(final int playlistId);}
```



Create views into a database

Version 2.1.0 and higher of the [Room persistence library](https://developer.android.com/training/data-storage/room/) provides support for [SQLite database views](https://www.sqlite.org/lang_createview.html), allowing you to encapsulate a query into a class. Room refers to these query-backed classes as *views*, and they behave the same as simple data objects when used in a [DAO](https://developer.android.com/training/data-storage/room/accessing-data).

**Note:** Like [entities](https://developer.android.com/training/data-storage/room/defining-data), you can run `SELECT` statements against views. However, you cannot run `INSERT`, `UPDATE`, or `DELETE`statements against views.

Create a view

To create a view, add the [`@DatabaseView`](https://developer.android.com/reference/androidx/room/DatabaseView) annotation to a class. Set the annotation's value to the query that the class should represent.

The following code snippet provides an example of a view:

[KOTLIN](https://developer.android.com/training/data-storage/room/creating-views#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/creating-views#java)

```java
@DatabaseView("SELECT user.id, user.name, user.departmentId," +
              "department.name AS departmentName FROM user " +
              "INNER JOIN department ON user.departmentId = department.id")
public class UserDetail {
    public long id;
    public String name;
    public long departmentId;
    public String departmentName;
}
```



Associate a view with your database

To include this view as part of your app's database, include the [`views`](https://developer.android.com/reference/androidx/room/Database#views) property in your app's `@Database`annotation:

[KOTLIN](https://developer.android.com/training/data-storage/room/creating-views#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/creating-views#java)

```
@Database(entities = {User.class}, **views = {UserDetail.class}**,          version = 1)public abstract class AppDatabase extends RoomDatabase {    public abstract UserDao userDao();}
```



Accessing data using Room DAOs

To access your app's data using the [Room persistence library](https://developer.android.com/training/data-storage/room/index.html), you work with *data access objects*, or DAOs. This set of [`Dao`](https://developer.android.com/reference/androidx/room/Dao.html) objects forms the main component of Room, as each DAO includes methods that offer abstract access to your app's database.

By accessing a database using a DAO class instead of query builders or direct queries, you can separate different components of your database architecture. Furthermore, DAOs allow you to easily mock database access as you [test your app](https://developer.android.com/training/data-storage/room/testing-db.html).

**Note:** Before adding DAO classes to your app, [add the Architecture Components artifacts](https://developer.android.com/topic/libraries/architecture/adding-components.html) to your app's `build.gradle` file.

A DAO can be either an interface or an abstract class. If it's an abstract class, it can optionally have a constructor that takes a [`RoomDatabase`](https://developer.android.com/reference/androidx/room/RoomDatabase.html) as its only parameter. Room creates each DAO implementation at compile time.

**Note:** Room doesn't support database access on the main thread unless you've called [`allowMainThreadQueries()`](https://developer.android.com/reference/androidx/room/RoomDatabase.Builder.html#allowMainThreadQueries()) on the builder because it might lock the UI for a long period of time. Asynchronous queries—queries that return instances of [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) or [`Flowable`](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html)—are exempt from this rule because they asynchronously run the query on a background thread when needed.

Define methods for convenience

There are multiple convenience queries that you can represent using a DAO class. This document includes several common examples.

Insert

When you create a DAO method and annotate it with [`@Insert`](https://developer.android.com/reference/androidx/room/Insert.html), Room generates an implementation that inserts all parameters into the database in a single transaction.

The following code snippet shows several example queries:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    public void insertUsers(User... users);

    @Insert
    public void insertBothUsers(User user1, User user2);

    @Insert
    public void insertUsersAndFriends(User user, List<User> friends);
}
```



If the [`@Insert`](https://developer.android.com/reference/androidx/room/Insert.html) method receives only 1 parameter, it can return a `long`, which is the new `rowId` for the inserted item. If the parameter is an array or a collection, it should return `long[]` or `List<Long>` instead.

For more details, see the reference documentation for the [`@Insert`](https://developer.android.com/reference/androidx/room/Insert.html) annotation, as well as the [SQLite documentation for rowid tables](https://www.sqlite.org/rowidtable.html).

Update

The [`Update`](https://developer.android.com/reference/androidx/room/Update.html) convenience method modifies a set of entities, given as parameters, in the database. It uses a query that matches against the primary key of each entity.

The following code snippet demonstrates how to define this method:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Update
    public void updateUsers(User... users);
}
```



Although usually not necessary, you can have this method return an `int` value instead, indicating the number of rows updated in the database.

Delete

The [`Delete`](https://developer.android.com/reference/androidx/room/Delete.html) convenience method removes a set of entities, given as parameters, from the database. It uses the primary keys to find the entities to delete.

The following code snippet demonstrates how to define this method:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Delete
    public void deleteUsers(User... users);
}
```



Although usually not necessary, you can have this method return an `int` value instead, indicating the number of rows removed from the database.

Query for information

[`@Query`](https://developer.android.com/reference/androidx/room/Query.html) is the main annotation used in DAO classes. It allows you to perform read/write operations on a database. Each [`@Query`](https://developer.android.com/reference/androidx/room/Query.html) method is verified at compile time, so if there is a problem with the query, a compilation error occurs instead of a runtime failure.

Room also verifies the return value of the query such that if the name of the field in the returned object doesn't match the corresponding column names in the query response, Room alerts you in one of the following two ways:

- It gives a warning if only some field names match.
- It gives an error if no field names match.

Simple queries

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * FROM user")
    public User[] loadAllUsers();
}
```



This is a very simple query that loads all users. At compile time, Room knows that it is querying all columns in the user table. If the query contains a syntax error, or if the user table doesn't exist in the database, Room displays an error with the appropriate message as your app compiles.

Passing parameters into the query

Most of the time, you need to pass parameters into queries to perform filtering operations, such as displaying only users who are older than a certain age. To accomplish this task, use method parameters in your Room annotation, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * FROM user WHERE age > :minAge")
    public User[] loadAllUsersOlderThan(int minAge);
}
```



When this query is processed at compile time, Room matches the `:minAge` bind parameter with the `minAge`method parameter. Room performs the match using the parameter names. If there is a mismatch, an error occurs as your app compiles.

You can also pass multiple parameters or reference them multiple times in a query, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * FROM user WHERE age BETWEEN :minAge AND :maxAge")
    public User[] loadAllUsersBetweenAges(int minAge, int maxAge);

    @Query("SELECT * FROM user WHERE first_name LIKE :search " +
           "OR last_name LIKE :search")
    public List<User> findUserWithName(String search);
}
```



Returning subsets of columns

Most of the time, you need to get only a few fields of an entity. For example, your UI might display just a user's first name and last name, rather than every detail about the user. By fetching only the columns that appear in your app's UI, you save valuable resources, and your query completes more quickly.

Room allows you to return any Java-based object from your queries as long as the set of result columns can be mapped into the returned object. For example, you can create the following plain old Java-based object (POJO) to fetch the user's first name and last name:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
public class NameTuple {
    @ColumnInfo(name = "first_name")
    public String firstName;

    @ColumnInfo(name = "last_name")
    @NonNull
    public String lastName;
}
```



Now, you can use this POJO in your query method:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT first_name, last_name FROM user")
    public List<NameTuple> loadFullName();
}
```



Room understands that the query returns values for the `first_name` and `last_name` columns and that these values can be mapped into the fields of the `NameTuple` class. Therefore, Room can generate the proper code. If the query returns too many columns, or a column that doesn't exist in the `NameTuple` class, Room displays a warning.

**Note:** These POJOs can also use the [`@Embedded`](https://developer.android.com/reference/androidx/room/Embedded.html) annotation.

Passing a collection of arguments

Some of your queries might require you to pass in a variable number of parameters, with the exact number of parameters not known until runtime. For example, you might want to retrieve information about all users from a subset of regions. Room understands when a parameter represents a collection and automatically expands it at runtime based on the number of parameters provided.

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT first_name, last_name FROM user WHERE region IN (:regions)")
    public List<NameTuple> loadUsersFromRegions(List<String> regions);
}
```



Observable queries

When performing queries, you'll often want your app's UI to update automatically when the data changes. To achieve this, use a return value of type [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) in your query method description. Room generates all necessary code to update the [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) when the database is updated.

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT first_name, last_name FROM user WHERE region IN (:regions)")
    public LiveData<List<User>> loadUsersFromRegionsSync(List<String> regions);
}
```



**Note:** As of version 1.0, Room uses the list of tables accessed in the query to decide whether to update instances of [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html).

Reactive queries with RxJava

Room provides the following support for return values of RxJava2 types:

- `@Query` methods: Room supports return values of type [`Publisher`](http://www.reactive-streams.org/reactive-streams-1.0.1-javadoc/org/reactivestreams/Publisher.html), [`Flowable`](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html), and [`Observable`](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Observable.html).
- `@Insert`, `@Update`, and `@Delete` methods: Room 2.1.0 and higher supports return values of type[`Completable`](http://reactivex.io/RxJava/javadoc/io/reactivex/Completable.html), [`Single`](http://reactivex.io/RxJava/javadoc/io/reactivex/Single.html), and [`Maybe`](http://reactivex.io/RxJava/javadoc/io/reactivex/Maybe.html).

To use this functionality, include the latest version of the **rxjava2** artifact in your app's `build.gradle` file:

app/build.gradle

```groovy
dependencies {
    implementation 'androidx.room:room-rxjava2:2.1.0-beta01'
}
```



The following code snippet shows several examples of how you might use these return types:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * from user where id = :id LIMIT 1")
    public Flowable<User> loadUserById(int id);

    // Emits the number of users added to the database.
    @Insert
    public Maybe<Integer> insertLargeNumberOfUsers(List<User> users);

    // Makes sure that the operation finishes successfully.
    @Insert
    public Completable insertLargeNumberOfUsers(User... users);

    /* Emits the number of users removed from the database. Always emits at
       least one user. */
    @Delete
    public Single<Integer> deleteUsers(List<User> users);
}
```



For more details, see the Google Developers [Room and RxJava](https://medium.com/google-developers/room-rxjava-acb0cd4f3757) article.

Direct cursor access

If your app's logic requires direct access to the return rows, you can return a `Cursor` object from your queries, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * FROM user WHERE age > :minAge LIMIT 5")
    public Cursor loadRawUsersOlderThan(int minAge);
}
```



**Caution:** It's highly discouraged to work with the Cursor API because it doesn't guarantee whether the rows exist or what values the rows contain. Use this functionality only if you already have code that expects a cursor and that you can't refactor easily.

Querying multiple tables

Some of your queries might require access to multiple tables to calculate the result. Room allows you to write any query, so you can also join tables. Furthermore, if the response is an observable data type, such as[`Flowable`](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html) or [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html), Room watches all tables referenced in the query for invalidation.

The following code snippet shows how to perform a table join to consolidate information between a table containing users who are borrowing books and a table containing data about books currently on loan:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
    @Query("SELECT * FROM book " +
           "INNER JOIN loan ON loan.book_id = book.id " +
           "INNER JOIN user ON user.id = loan.user_id " +
           "WHERE user.name LIKE :userName")
   public List<Book> findBooksBorrowedByNameSync(String userName);
}
```



You can also return POJOs from these queries. For example, you can write a query that loads a user and their pet's name as follows:

[KOTLIN](https://developer.android.com/training/data-storage/room/accessing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/accessing-data#java)

```java
@Dao
public interface MyDao {
   @Query("SELECT user.name AS userName, pet.name AS petName " +
          "FROM user, pet " +
          "WHERE user.id = pet.user_id")
   public LiveData<List<UserPet>> loadUserAndPetNames();

   // You can also define this class in a separate file, as long as you add the
   // "public" access modifier.
   static class UserPet {
       public String userName;
       public String petName;
   }
}
```



Write async methods with Kotlin coroutines

You can add the `suspend` Kotlin keyword to your DAO methods to make them asynchronous using Kotlin coroutines functionality. This ensures that they cannot be executed on the main thread.

```kotlin
@Dao
interface MyDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUsers(vararg users: User)

    @Update
    suspend fun updateUsers(vararg users: User)

    @Delete
    suspend fun deleteUsers(vararg users: User)

    @Query("SELECT * FROM user")
    suspend fun loadAllUsers(): Array<User>
}
```



**Note:** Using Room with Kotlin coroutines requires Room 2.1.0, Kotlin 1.3.0, and Coroutines 1.0.0 or higher. For more information, see [Declaring dependencies](https://developer.android.com/jetpack/androidx/releases/room#declaring_dependencies).

This guidance also applies to DAO methods annotated with [`@Transaction`](https://developer.android.com/reference/androidx/room/Transaction). You can use this feature to build suspending database methods out of other DAO methods. These methods then run in a single database transaction.

```kotlin
@Dao
abstract class UsersDao {
    @Transaction
    open suspend fun setLoggedInUser(loggedInUser: User) {
        deleteUser(loggedInUser)
        insertUser(loggedInUser)
    }

    @Query("DELETE FROM users")
    abstract fun deleteUser(user: User)

    @Insert
    abstract suspend fun insertUser(user: User)
}
```



**Caution:** Avoid doing extra app-side work within a single database transaction, as Room treats transactions as exclusive, and only performs one at a time, in order. This means that transactions that contain more operations than necessary can easily lock up your database and affect performance.

For more information on using Kotlin coroutines in your app, see [Improve app performance with Kotlin coroutines](https://developer.android.com/kotlin/coroutines).



Migrating Room databases

As you add and change features in your app, you need to modify your entity classes to reflect these changes. When a user updates to the latest version of your app, you don't want them to lose all of their existing data, especially if you can't recover the data from a remote server.

The [Room persistence library](https://developer.android.com/training/data-storage/room/index.html) allows you to write [`Migration`](https://developer.android.com/reference/androidx/room/migration/Migration.html) classes to preserve user data in this manner. Each[`Migration`](https://developer.android.com/reference/androidx/room/migration/Migration.html) class specifies a `startVersion` and `endVersion`. At runtime, Room runs each [`Migration`](https://developer.android.com/reference/androidx/room/migration/Migration.html) class's [`migrate()`](https://developer.android.com/reference/androidx/room/migration/Migration.html#migrate(android.arch.persistence.db.SupportSQLiteDatabase))method, using the correct order to migrate the database to a later version.

[KOTLIN](https://developer.android.com/training/data-storage/room/migrating-db-versions#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/migrating-db-versions#java)

```java
static final Migration MIGRATION_1_2 = new Migration(1, 2) {
    @Override
    public void migrate(SupportSQLiteDatabase database) {
        database.execSQL("CREATE TABLE `Fruit` (`id` INTEGER, "
                + "`name` TEXT, PRIMARY KEY(`id`))");
    }
};

static final Migration MIGRATION_2_3 = new Migration(2, 3) {
    @Override
    public void migrate(SupportSQLiteDatabase database) {
        database.execSQL("ALTER TABLE Book "
                + " ADD COLUMN pub_year INTEGER");
    }
};

Room.databaseBuilder(getApplicationContext(), MyDb.class, "database-name")
        .addMigrations(MIGRATION_1_2, MIGRATION_2_3).build();
```



**Caution:** To keep your migration logic functioning as expected, use full queries instead of referencing constants that represent the queries.

After the migration process finishes, Room validates the schema to ensure that the migration occurred correctly. If Room finds a problem, it throws an exception that contains the mismatched information.

Test migrations

Migrations aren't trivial to write, and failure to write them properly could cause a crash loop in your app. To preserve your app's stability, you should test your migrations beforehand. Room provides a **testing** Maven artifact to assist with this testing process. However, for this artifact to work, you need to export your database's schema.

Export schemas

Upon compilation, Room exports your database's schema information into a JSON file. To export the schema, set the `room.schemaLocation` annotation processor property in your `build.gradle` file, as shown in the following code snippet:

build.gradle

```groovy
android {
    ...
    defaultConfig {
        ...
        javaCompileOptions {
            annotationProcessorOptions {
                arguments = ["room.schemaLocation":
                             "$projectDir/schemas".toString()]
            }
        }
    }
}
```



You should store the exported JSON files—which represent your database's schema history—in your version control system, as it allows Room to create older versions of your database for testing purposes.

To test these migrations, add the **android.arch.persistence.room:testing** Maven artifact from Room into your test dependencies, and add the schema location as an asset folder, as shown in the following code snippet:

build.gradle

```groovy
android {
    ...
    sourceSets {
        androidTest.assets.srcDirs += files("$projectDir/schemas".toString())
    }
}
```



The testing package provides a [`MigrationTestHelper`](https://developer.android.com/reference/androidx/room/testing/MigrationTestHelper.html) class, which can read these schema files. It also implements the JUnit4 [`TestRule`](http://junit.org/junit4/javadoc/4.12/org/junit/rules/TestRule.html) interface, so it can manage created databases.

A sample migration test appears in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/migrating-db-versions#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/migrating-db-versions#java)

```java
@RunWith(AndroidJUnit4.class)
public class MigrationTest {
    private static final String TEST_DB = "migration-test";

    @Rule
    public MigrationTestHelper helper;

    public MigrationTest() {
        helper = new MigrationTestHelper(InstrumentationRegistry.getInstrumentation(),
                MigrationDb.class.getCanonicalName(),
                new FrameworkSQLiteOpenHelperFactory());
    }

    @Test
    public void migrate1To2() throws IOException {
        SupportSQLiteDatabase db = helper.createDatabase(TEST_DB, 1);

        // db has schema version 1. insert some data using SQL queries.
        // You cannot use DAO classes because they expect the latest schema.
        db.execSQL(...);

        // Prepare for the next version.
        db.close();

        // Re-open the database with version 2 and provide
        // MIGRATION_1_2 as the migration process.
        db = helper.runMigrationsAndValidate(TEST_DB, 2, true, MIGRATION_1_2);

        // MigrationTestHelper automatically verifies the schema changes,
        // but you need to validate that the data was migrated properly.
    }
}
```



Gracefully handle missing migration paths

After updating your database's schemas, it's possible that some on-device databases could still use an older schema version. If Room cannot find a migration rule for upgrading that device's database from the older version to the current version, an [`IllegalStateException`](https://developer.android.com/reference/java/lang/IllegalStateException) occurs.

To prevent the app from crashing when this situation occurs, call the `fallbackToDestructiveMigration()` builder method when creating the database:

[KOTLIN](https://developer.android.com/training/data-storage/room/migrating-db-versions#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/migrating-db-versions#java)

```java
Room.databaseBuilder(getApplicationContext(), MyDb.class, "database-name")
        .fallbackToDestructiveMigration()
        .build();
```



By including this clause in your app's database-building logic, you tell Room to destructively recreate your app's database tables in cases where a migration path between schema versions is missing.

**Warning:** By configuring this option in your app's database builder, Room **permanently deletes all data**from the database tables when a migration path is missing.

The destructive recreation fallback logic includes several additional options:

- If errors occur in specific versions of your schema history that you cannot solve with migration paths, use[`fallbackToDestructiveMigrationFrom()`](https://developer.android.com/reference/androidx/room/RoomDatabase.Builder#fallbacktodestructivemigrationfrom). This method indicates that you'd like Room to use the fallback logic only in cases where the database attempts to migrate from one of those problematic versions.
- To perform a destructive recreation only when attempting a schema downgrade, use[`fallbackToDestructiveMigrationOnDowngrade()`](https://developer.android.com/reference/androidx/room/RoomDatabase.Builder#fallbacktodestructivemigrationondowngrade) instead.



Testing your database

It's important to verify the stability of your app's database and your users' data when creating databases using the [Room persistence library](https://developer.android.com/training/data-storage/room/index.html).

There are 2 ways to test your database:

- On an Android device.
- On your host development machine (not recommended).

For information about testing that's specific to database migrations, see [Testing Migrations](https://developer.android.com/training/data-storage/room/migrating-db-versions.html#test).

**Note:** When running tests for your app, Room allows you to create mock instances of your [DAO](https://developer.android.com/training/data-storage/room/accessing-data.html) classes. That way, you don't need to create a full database if you aren't testing the database itself. This functionality is possible because your DAOs don't leak any details of your database.

Test on an Android device

The recommended approach for testing your database implementation is writing a JUnit test that runs on an Android device. Because these tests don't require creating an activity, they should be faster to execute than your UI tests.

When setting up your tests, you should create an in-memory version of your database to make your tests more hermetic, as shown in the following example:

[KOTLIN](https://developer.android.com/training/data-storage/room/testing-db#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/testing-db#java)

```java
@RunWith(AndroidJUnit4.class)
public class SimpleEntityReadWriteTest {
    private UserDao userDao;
    private TestDatabase db;

    @Before
    public void createDb() {
        Context context = ApplicationProvider.getApplicationContext();
        db = Room.inMemoryDatabaseBuilder(context, TestDatabase.class).build();
        userDao = db.getUserDao();
    }

    @After
    public void closeDb() throws IOException {
        db.close();
    }

    @Test
    public void writeUserAndReadInList() throws Exception {
        User user = TestUtil.createUser(3);
        user.setName("george");
        userDao.insert(user);
        List<User> byName = userDao.findUsersByName("george");
        assertThat(byName.get(0), equalTo(user));
    }
}
```



Test on your host machine

Room uses the SQLite Support Library, which provides interfaces that match those in the Android Framework classes. This support allows you to pass custom implementations of the support library to test your database queries.

**Note:** Even though this setup allows your tests to run very quickly, it isn't recommended because the version of SQLite running on your device—and your users' devices—might not match the version on your host machine.



Referencing complex data using Room

Room provides functionality for converting between primitive and boxed types but doesn't allow for object references between entities. This document explains how to use type converters and why Room doesn't support object references.

Use type converters

Sometimes, your app needs to use a custom data type whose value you would like to store in a single database column. To add this kind of support for custom types, you provide a [`TypeConverter`](https://developer.android.com/reference/androidx/room/TypeConverter.html), which converts a custom class to and from a known type that Room can persist.

For example, if we want to persist instances of `Date`, we can write the following [`TypeConverter`](https://developer.android.com/reference/androidx/room/TypeConverter.html) to store the equivalent Unix timestamp in the database:

[KOTLIN](https://developer.android.com/training/data-storage/room/referencing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/referencing-data#java)

```java
public class Converters {
    @TypeConverter
    public static Date fromTimestamp(Long value) {
        return value == null ? null : new Date(value);
    }

    @TypeConverter
    public static Long dateToTimestamp(Date date) {
        return date == null ? null : date.getTime();
    }
}
```



The preceding example defines 2 functions, one that converts a `Date` object to a `Long` object and another that performs the inverse conversion, from `Long` to `Date`. Since Room already knows how to persist `Long` objects, it can use this converter to persist values of type `Date`.

Next, you add the [`@TypeConverters`](https://developer.android.com/reference/androidx/room/TypeConverters.html) annotation to the `AppDatabase` class so that Room can use the converter that you've defined for each [entity](https://developer.android.com/training/data-storage/room/defining-data.html) and [DAO](https://developer.android.com/training/data-storage/room/accessing-data.html) in that `AppDatabase`:

AppDatabase

[KOTLIN](https://developer.android.com/training/data-storage/room/referencing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/referencing-data#java)

```java
@Database(entities = {User.class}, version = 1)
@TypeConverters({Converters.class})
public abstract class AppDatabase extends RoomDatabase {
    public abstract UserDao userDao();
}
```



Using these converters, you can then use your custom types in other queries, just as you would use primitive types, as shown in the following code snippet:

User

[KOTLIN](https://developer.android.com/training/data-storage/room/referencing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/referencing-data#java)

```java
@Entity
public class User {
    private Date birthday;
}
```



UserDao

[KOTLIN](https://developer.android.com/training/data-storage/room/referencing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/referencing-data#java)

```java
@Dao
public interface UserDao {
    @Query("SELECT * FROM user WHERE birthday BETWEEN :from AND :to")
    List<User> findUsersBornBetweenDates(Date from, Date to);
}
```



You can also limit the [`@TypeConverters`](https://developer.android.com/reference/androidx/room/TypeConverters.html) to different scopes, including individual entities, DAOs, and DAO methods. For more details, see the reference documentation for the [`@TypeConverters`](https://developer.android.com/reference/androidx/room/TypeConverters.html) annotation.

Understand why Room doesn't allow object references

**Key takeaway:** Room disallows object references between entity classes. Instead, you must explicitly request the data that your app needs.

Mapping relationships from a database to the respective object model is a common practice and works very well on the server side. Even when the program loads fields as they're accessed, the server still performs well.

However, on the client side, this type of lazy loading isn't feasible because it usually occurs on the UI thread, and querying information on disk in the UI thread creates significant performance problems. The UI thread typically has about 16 ms to calculate and draw an activity's updated layout, so even if a query takes only 5 ms, it's still likely that your app will run out of time to draw the frame, causing noticeable visual glitches. The query could take even more time to complete if there's a separate transaction running in parallel, or if the device is running other disk-intensive tasks. If you don't use lazy loading, however, your app fetches more data than it needs, creating memory consumption problems.

Object-relational mappings usually leave this decision to developers so that they can do whatever is best for their app's use cases. Developers usually decide to share the model between their app and the UI. This solution doesn't scale well, however, because as the UI changes over time, the shared model creates problems that are difficult for developers to anticipate and debug.

For example, consider a UI that loads a list of `Book` objects, with each book having an `Author` object. You might initially design your queries to use lazy loading to have instances of `Book` retrieve the author. The first retrieval of the `author` field queries the database. Some time later, you realize that you need to display the author name in your app's UI, as well. You can access this name easily enough, as shown in the following code snippet:

[KOTLIN](https://developer.android.com/training/data-storage/room/referencing-data#kotlin)[JAVA](https://developer.android.com/training/data-storage/room/referencing-data#java)

```java
authorNameTextView.setText(book.getAuthor().getName());
```



However, this seemingly innocent change causes the `Author` table to be queried on the main thread.

If you query author information ahead of time, it becomes difficult to change how data is loaded if you no longer need that data. For example, if your app's UI no longer needs to display `Author` information, your app effectively loads data that it no longer displays, wasting valuable memory space. Your app's efficiency degrades even further if the `Author` class references another table, such as `Books`.

To reference multiple entities at the same time using Room, you instead create a POJO that contains each entity, then write a query that joins the corresponding tables. This well-structured model, combined with Room's robust query validation capabilities, allows your app to consume fewer resources when loading data, improving your app's performance and user experience.











