//
//  ProfileAvatarView.swift
//  Ecommerce
//
//  Reusable profile avatar: shows stored profile image from UserDefaults
//  (set when profile is fetched) or system person icon fallback.
//

import SwiftUI

struct ProfileAvatarView: View {

    @AppStorage(UserDefaultsKeys.profileImageURL) private var profileImageURLString: String = ""

    var body: some View {
        if let url = URL(string: profileImageURLString), !profileImageURLString.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    fallbackIcon
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                @unknown default:
                    fallbackIcon
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
        } else {
            fallbackIcon
        }
    }

    private var fallbackIcon: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.yellow)
            .frame(width: 50, height: 50)
    }
}
