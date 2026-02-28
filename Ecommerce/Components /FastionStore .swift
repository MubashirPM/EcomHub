//
//  FastionStore .swift
//  Ecommerce
//
//  Created by Mubashir PM on 10/02/26.
//

import SwiftUI

struct FastionStore_: View {
    var body: some View {
        VStack(spacing: -8){
            
            HStack(spacing: 0) {
                Text("F")
                    .font(.custom("Pacifico-Regular", size: 40))
                    .foregroundStyle(.red)
                
                Text("ashion")
                    .font(.custom("Pacifico-Regular", size: 40))
                    .foregroundColor(.white)
            }
            Text("Store")
                .font(.custom("Pacifico-Regular", size: 40))
                       .foregroundColor(.white)
                       .padding(.top, -8)
            
        }
        
    }
}

#Preview {
    FastionStore_()
        
}
