class Version implements Comparable<Version> {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch);

  factory Version.parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid version format. Expected x.y.z');
    }
    return Version(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  int compareTo(Version other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  bool operator > (Version other) => compareTo(other) > 0;
  bool operator < (Version other) => compareTo(other) < 0;
  bool operator >= (Version other) => compareTo(other) >= 0;
  bool operator <= (Version other) => compareTo(other) <= 0;

  @override
  bool operator == (Object other) =>
      other is Version &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch;
  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
