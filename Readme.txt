Ngữ cảnh (images):
	•	Ảnh 3380 (đính kèm): popup hiển thị kết quả đo (chim bay 42.57 km, tuyến đường 77.29 km • 91 phút, % chênh lệch 81.6%). Nút ✕ Xóa hiện chỉ xóa đường trên bản đồ nhưng không xóa metadata/ảnh; layout nút nhỏ, nằm sát, dễ bấm nhầm trên mobile.
	•	Ảnh 3382 (đính kèm): modal Điều hướng hiển thị menu; modal bị đặt quá thấp, bị che/đè bởi UI trình duyệt (iOS bottom bar). Giao diện menu bị chồng, khoảng cách nội dung nhỏ, không tận dụng safe-area, touch targets nhỏ.

Mục tiêu: cải thiện trải nghiệm trên thiết bị di động — auto-detect thiết bị, sửa logic trong settings, sửa lỗi xóa ảnh/metadata (3380), sửa menu modal (3382), tránh phần tử chồng lấn trên mobile, tối ưu gallery/marker VN, và thêm tối thiểu 2 tính năng mới (1 mobile, 1 desktop).

Yêu cầu cụ thể (hành vi & fix)
	1.	Auto-detect Mobile
	•	Thêm tùy chọn setting: Auto (mặc định) / Force Mobile / Force Desktop.
	•	Nếu Auto và trình duyệt client hint hoặc user agent là mobile => tự chuyển layout mobile; nhưng không ghi đè Force Desktop.
	•	Hiển thị label nhỏ: Đã phát hiện: Mobile (iOS/Android) khi auto bật.
	2.	Popup đo — ảnh 3380
	•	Khi người dùng bấm Xóa trên popup:
	•	Xóa toàn bộ dữ liệu liên quan: đường (path), ảnh/URL, metadata (title, mô tả, liên kết) trên UI và gửi yêu cầu xóa backend (transactional).
	•	Hiện confirmation dialog hoặc snackbar Đã xóa — Hoàn tác (undo trong 5s).
	•	Nâng kích thước touch target cho 2 nút (Xóa, Sao chép) tối thiểu 44×44 dp, tăng khoảng cách giữa 2 nút.
	•	Khi xóa thất bại (network/backend error) => show error toast, không để UI ở trạng thái nửa chừng.
	3.	Menu Điều hướng — ảnh 3382
	•	Modal phải tôn trọng iOS/Android safe area: padding-bottom = env(safe-area-inset-bottom).
	•	Đảm bảo modal không bị che bởi bottom browser bar; nếu cần, tăng height/offset hoặc dùng full-screen sheet (kéo lên).
	•	Tăng spacing giữa menu items; tăng kích thước icon + text; đảm bảo min touch target 44×44.
	•	Thêm close affordance rõ ràng và focus trap khi modal mở (for accessibility).
	4.	Tránh UI chồng lấn / responsive
	•	Thêm breakpoints: mobile ≤ 768px; tablet 769–1024px; desktop >1024px.
	•	Dùng display:flex / gap và avoid hard-coded margins; dùng z-index logic rõ ràng cho modal/panels.
	•	Kiểm tra trên màn hình iPhone phổ biến (360×800, 375×812, 390×844) để đảm bảo không chồng.
	5.	Marker VN & ảnh minh họa
	•	Nếu API trả lỗi ảnh => hiển thị placeholder + “Ảnh không tải được”.
	•	Thay gallery dọc thành carousel ngang (swipe/scroll ngang), mỗi item: thumbnail + title ngắn + tỉnh/thành + mô tả 2–3 dòng.
	•	Preload thumbnails, lazy-load full images, fallback retry 1 lần.
	6.	Settings — logic & grouping
	•	Gom tất cả tùy chọn mobile vào nhóm Mobile Support.
	•	Các option đề xuất: Enable gestures, Enable Lite Mode (low density), Auto-detect device, Force Mobile / Force Desktop, Image preload: On/Off.
	•	Nếu user bật Auto-detect, show detected platform bên cạnh.
	7.	Gesture & mobile interactions
	•	Thêm gestures: swipe-left để xóa (với undo), long-press để mở context menu, tap để chọn/zoom.
	•	Cho phép trong settings Gesture Shortcut Editor (tùy chỉnh 2 gesture), nếu muốn.
	8.	Performance & accessibility
	•	Dùng IntersectionObserver cho lazy-load, srcset/WebP cho ảnh.
	•	Thêm aria-* cho modal, buttons; keyboard nav cho desktop.
	•	Thêm logging cho ảnh tải thất bại.

2 tính năng mới (bắt buộc, tối thiểu)
	•	Mobile: Lite Mode — giao diện tối giản (1-col, giảm animation, ít nội dung) để dùng khi mạng yếu / tiết kiệm pin.
	•	Desktop: Resizable Side Panel — cho phép kéo to/nhỏ sidebar thông tin địa danh; lưu kích thước vào localStorage.

Acceptance criteria (QA)
	•	Truy cập từ mobile với Auto => UI chuyển mobile và hiển thị label detected.
	•	Bấm Xóa trên popup 3380 xóa cả đường + metadata; có undo trong 5s; backend trả success.
	•	Menu 3382 không bị che bởi bottom browser bar; item không chồng; touch targets ok.
	•	Marker VN: nếu ảnh lỗi => placeholder; gallery ngang hoạt động swipe.
	•	Tất cả button chính có touch target ≥44×44 và spacing hợp lý trên màn hình 375×812.
	•	Lite Mode hoạt động (giảm animation & density).
	•	Resizable panel trên desktop lưu trạng thái giữa các lần truy cập.

Gợi ý kỹ thuật (tóm tắt)
	•	Frontend: CSS media queries + env(safe-area-inset-*), flex/gap, IntersectionObserver, srcset.
	•	Gestures: native Pointer Events hoặc Hammer.js.
	•	Backend: endpoint delete phải xóa cả metadata & file, thực hiện trong transaction; trả JSON {deleted:true}.
	•	UX: snackbar undo, confirmation modal, placeholders.

QA checklist nhanh (copy-paste)
	•	Auto-detect mobile on/off behavior
	•	Popup 3380: delete metadata + undo
	•	Menu 3382: safe-area & no overlap with browser bottom
	•	Touch target >=44×44 for main buttons
	•	Marker VN: horizontal carousel + image fallback
	•	Lite Mode implemented
	•	Resizable side panel on desktop
	•	Error handling & logging for image loads

PR / commit message gợi ý

fix(mobile): auto-detect mobile, fix popup 3380 deletion & menu 3382 safe-area, horizontal VN gallery, add Lite Mode + resizable panel
