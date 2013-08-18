	using Almanna;
	using Gee;
	namespace Parchment.Model.DB.Implementation {
		
		/**
		 * Almanna Implementation for class "Entry".
		 * Generated by almanna-generate.
		 */
		public class Entry : Parchment.Model.DB.Entity.Entry {
			public Publisher publisher { get; set; }
			public ArrayList<EntryTag> entry_tags { get; set; }
	
			public override void register_entity() {
				base.register_entity();
	
				add_has_one( "publisher", "publisher_id", "publisher_id" );
				add_has_many( "entry_tags", typeof(EntryTag), "entry_id", "entry_id" );
				add_has_many( "comments", typeof(Comment), "entry_id", "entry_id" );
			}

			/**
			 * Constructor to automatically set date_created to now when
			 * instantiated.
			 */
			public Entry() {
				base();
				this.date_created = new DateTime.now_local();
			}

			/**
			 * Override save to set date_modified on every update.
			 */
			public override void save() {
				this.date_modified = new DateTime.now_local();
				base.save();
			}

			/**
			 * Get comment count for entry.
			 */
			public int comment_count() {
				return (int) this.get_related_search("comments").count();
			}

			/**
			 * Get ArrayList of Comment objects.
			 */
			public ArrayList<Comment> comments() {
				var comments = this.get_related_search("comments")
								.order_by("date_created")
								.list();
				var real_comments = new ArrayList<Comment>();
				foreach ( var comment in comments ) {
					real_comments.add( (Comment) comment );
				}
				return real_comments;
			}

			/**
			 * Retrieve total entry count.
			 */
			public static int entry_count() {
				return (int) Entry.joined_search().count();
			}

			/**
			 * Retrieve a new Search with the publisher relationship.
			 */
			public static Search<Entry> joined_search() {
				return new Search<Entry>()              // Create a Search
							.relationship("publisher"); // Use publisher relationship
			}

			/**
			 * Get page of entries.
			 * @param page Page number
			 */
			public static Search<Entry> paged_entries( int page ) {
				return Entry.joined_search()
						.order_by( "date_created", true ) // Order by, descending
						.rows(10)                         // Show 10 entries per page
						.page(page);
			}
		}
	}
	