--       CREATE TRIGGER update_or_insert_stocks_summaries_on_create
--       AFTER INSERT
--       ON stocks
--       FOR EACH ROW
--       BEGIN
--           -- Update existing row if stock combination already exists
-- --           UPDATE stocks_summaries
-- --           SET total_stocks = total_stocks + 1
-- --           WHERE expiry  COLLATE utf8mb4_unicode_ci = NEW.expiry COLLATE utf8mb4_unicode_ci
-- --             AND item_master_id = NEW.item_master_id
-- --             AND lot_number COLLATE utf8mb4_unicode_ci = NEW.lot_number COLLATE utf8mb4_unicode_ci
-- --             AND storage_id = NEW.storage_id
-- --             AND stock_status COLLATE utf8mb4_unicode_ci = NEW.stock_status COLLATE utf8mb4_unicode_ci;
--
--           -- Insert new row if stock combination does not exist
-- --           IF ROW_COUNT() = 0 THEN
--               INSERT INTO stocks_summaries('expiry', 'item_master_id', 'lot_number', 'storage_id', 'stock_status', 'total_stocks', 'stock_created_at', 'created_at', 'updated_at')
--               VALUES (NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, NEW.created_at, NOW(),NOW());
-- --           END IF;
--       END;

--       CREATE TRIGGER update_or_insert_stocks_summaries_on_create
--           AFTER INSERT
--           ON stocks
--           FOR EACH ROW
--       BEGIN
--           INSERT INTO stocks_summaries('expiry', 'item_master_id', 'lot_number', 'storage_id', 'stock_status', 'total_stocks',
--                                        'stock_created_at', 'created_at', 'updated_at')
--           VALUES (NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, NEW.created_at, NOW(),
--                   NOW());
--       END;

# execute <<~SQL
#   CREATE TRIGGER update_stocks_summaries_trigger
#   AFTER UPDATE ON stocks FOR EACH ROW
#   BEGIN
#       -- update expiry, item_master_id, lot_number, and storage_id if updated
#       IF NEW.expiry <> OLD.expiry OR NEW.item_master_id <> OLD.item_master_id OR NEW.lot_number <> OLD.lot_number OR NEW.storage_id <> OLD.storage_id THEN
#           -- update expiry, item_master_id, lot_number, and storage_id of stock_summaries
#           UPDATE stocks_summaries
#           SET expiry = NEW.expiry COLLATE utf8mb4_unicode_ci,
#               item_master_id = NEW.item_master_id,
#               lot_number = NEW.lot_number COLLATE utf8mb4_unicode_ci,
#               storage_id = NEW.storage_id
#           WHERE expiry COLLATE utf8mb4_unicode_ci = OLD.expiry COLLATE utf8mb4_unicode_ci
#               AND item_master_id = OLD.item_master_id
#               AND lot_number COLLATE utf8mb4_unicode_ci = OLD.lot_number COLLATE utf8mb4_unicode_ci
#               AND storage_id = OLD.storage_id;
#       END IF;
#       -- update total_stocks base on the update of stock_status update
#       IF NEW.stock_status <> OLD.stock_status
#           -- start of updating old stock
#           DECLARE var_old_stock_row_count INT;
#           DECLARE var_old_stock_row_id INT;
#           DECLARE var_old_total_stock INT;
#           -- Get the id and count of old value for stock
#           SELECT id INTO var_old_stock_row_id, count(id) INTO var_old_stock_row_count, total_stock INTO var_old_total_stock
#             FROM stocks_summaries
#             WHERE expiry COLLATE utf8mb4_unicode_ci = OLD.expiry COLLATE utf8mb4_unicode_ci
#                 AND item_master_id = OLD.item_master_id
#                 AND lot_number COLLATE utf8mb4_unicode_ci = OLD.lot_number COLLATE utf8mb4_unicode_ci
#                 AND storage_id = OLD.storage_id
#                 AND stock_status COLLATE utf8mb4_unicode_ci = OLD.stock_status COLLATE utf8mb4_unicode_ci;
#           -- removing or decrease the total stocks based on total_stock present
#           IF var_old_total_stock = 1 THEN
#             DELETE FROM stocks_summaries WHERE id = var_old_stock_row_id;
#           ELSE
#             UPDATE stocks_summaries SET total_stock = total_stock - 1 WHERE id = var_old_stock_row_id;
#           END IF;
#           -- end of updating old stock
#           -- start of updating new stock
#           DECLARE var_new_stock_row_count INT;
#           DECLARE var_new_stock_row_id INT;
#           -- Get the id and count of old value for stock
#           SELECT id INTO var_old_stock_row_id, count(id) INTO var_old_stock_row_count
#             FROM stocks_summaries
#             WHERE expiry COLLATE utf8mb4_unicode_ci = NEW.expiry COLLATE utf8mb4_unicode_ci
#             AND item_master_id = NEW.item_master_id
#             AND lot_number COLLATE utf8mb4_unicode_ci = NEW.lot_number COLLATE utf8mb4_unicode_ci
#             AND storage_id = NEW.storage_id
#             AND stock_status COLLATE utf8mb4_unicode_ci = NEW.stock_status COLLATE utf8mb4_unicode_ci;
#           -- increase or create total_stock based on the present of the stock
#           IF var_new_stock_row_count > 0 THEN
#               UPDATE stocks_summaries SET total_stock = total_stock + 1 WHERE id = var_new_stock_row_id;
#           ELSE
#               INSERT INTO stocks_summaries( expiry, item_master_id, lot_number, storage_id, stock_status, total_stocks, created_at )
#               VALUES( NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, OLD.created_at );
#           END IF;
#           -- end of updating new stock
#       END IF;
#   END;
# SQL
# execute <<-SQL
#   CREATE TRIGGER update_stocks_summaries_trigger
#   AFTER UPDATE ON stocks FOR EACH ROW
#   BEGIN
#     -- update expiry, item_master_id, lot_number, and storage_id if updated
#     IF NEW.expiry <> OLD.expiry OR NEW.item_master_id <> OLD.item_master_id OR NEW.lot_number <> OLD.lot_number OR NEW.storage_id <> OLD.storage_id THEN
#         -- update expiry, item_master_id, lot_number, and storage_id of stock_summaries
#         UPDATE stocks_summaries
#         SET expiry = NEW.expiry COLLATE utf8mb4_unicode_ci,
#             item_master_id = NEW.item_master_id,
#             lot_number = NEW.lot_number COLLATE utf8mb4_unicode_ci,
#             storage_id = NEW.storage_id
#         WHERE expiry COLLATE utf8mb4_unicode_ci = OLD.expiry COLLATE utf8mb4_unicode_ci
#             AND item_master_id = OLD.item_master_id
#             AND lot_number COLLATE utf8mb4_unicode_ci = OLD.lot_number COLLATE utf8mb4_unicode_ci
#             AND storage_id = OLD.storage_id;
#     END IF;
#
#     -- update total_stocks based on the update of stock_status
#     IF NEW.stock_status <> OLD.stock_status THEN
#         -- start of updating old stock
#         DECLARE var_old_stock_row_count INT;
#         DECLARE var_old_stock_row_id INT;
#         DECLARE var_old_total_stock INT;
#
#         -- Get the id, count, and total_stock of old value for stock
#         SELECT id, count(id), total_stock INTO var_old_stock_row_id, var_old_stock_row_count, var_old_total_stock
#         FROM stocks_summaries
#         WHERE expiry COLLATE utf8mb4_unicode_ci = OLD.expiry COLLATE utf8mb4_unicode_ci
#             AND item_master_id = OLD.item_master_id
#             AND lot_number COLLATE utf8mb4_unicode_ci = OLD.lot_number COLLATE utf8mb4_unicode_ci
#             AND storage_id = OLD.storage_id
#             AND stock_status COLLATE utf8mb4_unicode_ci = OLD.stock_status COLLATE utf8mb4_unicode_ci;
#
#         -- remove or decrease the total stocks based on total_stock present
#         IF var_old_total_stock = 1 THEN
#             DELETE FROM stocks_summaries WHERE id = var_old_stock_row_id;
#         ELSE
#             UPDATE stocks_summaries SET total_stock = total_stock - 1 WHERE id = var_old_stock_row_id;
#         END IF;
#         -- end of updating old stock
#
#         -- start of updating new stock
#         DECLARE var_new_stock_row_count INT;
#         DECLARE var_new_stock_row_id INT;
#
#         -- Get the id and count of new value for stock
#         SELECT id, count(id) INTO var_new_stock_row_id, var_new_stock_row_count
#         FROM stocks_summaries
#         WHERE expiry COLLATE utf8mb4_unicode_ci = NEW.expiry COLLATE utf8mb4_unicode_ci
#             AND item_master_id = NEW.item_master_id
#             AND lot_number COLLATE utf8mb4_unicode_ci = NEW.lot_number COLLATE utf8mb4_unicode_ci
#             AND storage_id = NEW.storage_id
#             AND stock_status COLLATE utf8mb4_unicode_ci = NEW.stock_status COLLATE utf8mb4_unicode_ci;
#
#         -- increase or create total_stock based on the presence of the stock
#         IF var_new_stock_row_count > 0 THEN
#             UPDATE stocks_summaries SET total_stock = total_stock + 1 WHERE id = var_new_stock_row_id;
#         ELSE
#             INSERT INTO stocks_summaries(expiry, item_master_id, lot_number, storage_id, stock_status, total_stocks, created_at)
#             VALUES(NEW.expiry, NEW.item_master_id, NEW.lot_number, NEW.storage_id, NEW.stock_status, 1, OLD.created_at);
#         END IF;
#         -- end of updating new stock
#     END IF;
#   END;
# SQL