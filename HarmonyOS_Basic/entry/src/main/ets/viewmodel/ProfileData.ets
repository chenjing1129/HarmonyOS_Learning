// entry/src/main/ets/viewmodel/ProfileData.ts
export class ProfileData {
  name: string;
  avatar: Resource;
  bio: string;

  constructor(name: string, avatar: Resource, bio: string) {
    this.name = name;
    this.avatar = avatar;
    this.bio = bio;
  }
} 