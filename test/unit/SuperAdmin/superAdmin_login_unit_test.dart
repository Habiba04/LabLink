import 'package:flutter_test/flutter_test.dart';

void main() {
  group("SuperAdmin login logic unit tests", () {
    const superAdminEmail = "superadmin@lablink-admin.com";

    test("Super admin email comparison is case-insensitive & trimmed", () {
      String apiReturnedEmail = "  SUPERADMIN@lablink-admin.com  ";

      bool isSuperAdmin =
          apiReturnedEmail.trim().toLowerCase() ==
          superAdminEmail.trim().toLowerCase();

      expect(isSuperAdmin, true);
    });

    test("Non-super-admin email fails authorization", () {
      String email = "normal@test.com";

      bool isSuperAdmin =
          email.trim().toLowerCase() == superAdminEmail.trim().toLowerCase();

      expect(isSuperAdmin, false);
    });
  });
}
