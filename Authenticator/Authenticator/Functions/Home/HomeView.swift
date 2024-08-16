import SwiftUI
import CoreData

struct HomeView: View {
        @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TokenData.indexNumber, ascending: true)], animation: .default)
    
        private var fetchedTokens: FetchedResults<TokenData>
        
        @State private var presentingSheet: HomeActionE = .moreAbout
        @State private var tokenIndex: Int = 0
    
        private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var timeRemaining: Int = 30 - (Int(Date().timeIntervalSince1970) % 30)
        @State private var codes: [String] = Array(repeating: String.zeros, count: 50)
        @State private var animationTrigger: Bool = false
        
        @State private var isSheetPresented: Bool = false
        @State private var isFileImporterPresented: Bool = false
        
        @State private var editMode: EditMode = .inactive
        @State private var selectedTokens = Set<TokenData>()
        @State private var indexSetOnDelete: IndexSet = IndexSet()
        @State private var isDeletionAlertPresented: Bool = false
        @State private var searchedText: String = ""
        // search query
        var query: Binding<String> {
                Binding {
                        searchedText
                } set: { newValue in
                        searchedText = newValue
                        // check contains with all lowercase
                        if newValue.isEmpty {
                                fetchedTokens.nsPredicate = nil
                        } else {
                                let predicate = NSPredicate(format: "displayAccountName CONTAINS[c] %@ OR displayIssuer CONTAINS[c] %@", newValue, newValue)
                                fetchedTokens.nsPredicate = predicate
                        }
                }
            }
    
    @State private var isPresentedSetting = false
        
        init() {
                UITableView.appearance().sectionFooterHeight = 0
                UITextField.appearance().clearButtonMode = .always
        }
        
        var body: some View {
                NavigationView {
                    ZStack(alignment: .bottomTrailing) {
                        Image("home-background")
                            .resizable()
                            .ignoresSafeArea()
                        mainView
                        floatingButton
                            .padding(.bottom, 80)
                    }
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                    if editMode == .active {
                                            Button(action: {
                                                    editMode = .inactive
                                                    selectedTokens.removeAll()
                                                    indexSetOnDelete.removeAll()
                                            }) {
                                                    Text("Done")
                                            }
                                    } else {
                                        HStack {
                                            // setting button with gear icon
                                            Button {
                                                isPresentedSetting = true
                                            } label: {
                                                Image(systemName: "gear")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 26)
                                                    .padding(.trailing, 8)
                                                    .contentShape(Rectangle())
                                            }
                                            
                                            Menu {
                                                    Button(action: {
                                                            selectedTokens.removeAll()
                                                            indexSetOnDelete.removeAll()
                                                            editMode = .active
                                                    }) {
                                                            Label("Edit", systemImage: "list.bullet")
                                                    }
                                                    Button(action: {
                                                            presentingSheet = .moreExport
                                                            isSheetPresented = true
                                                    }) {
                                                            Label("Export", systemImage: "square.and.arrow.up")
                                                    }
                                                    Button(action: {
                                                            presentingSheet = .moreAbout
                                                            isSheetPresented = true
                                                    }) {
                                                            Label("About", systemImage: "info.circle")
                                                    }
                                            } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 26)
                                                            .padding(.trailing, 8)
                                                            .contentShape(Rectangle())
                                            }
                                        }
                                    }
                            }
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                    if editMode == .active {
                                            Button(role: .destructive) {
                                                    if !(selectedTokens.isEmpty) {
                                                            isDeletionAlertPresented = true
                                                    }
                                            } label: {
                                                    Image(systemName: "trash")
                                            }
                                    } else {
                                            Menu {
                                                    Button(action: {
                                                            presentingSheet = .addByScanning
                                                            isSheetPresented = true
                                                    }) {
                                                            Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                                                    }
                                                    Button(action: {
                                                            presentingSheet = .addByQRCodeImage
                                                            isSheetPresented = true
                                                    }) {
                                                            Label("Import from Photos", systemImage: "photo")
                                                    }
                                                    Button {
                                                            isFileImporterPresented = true
                                                    } label: {
                                                            Label("Import from Files", systemImage: "doc.badge.plus")
                                                    }
                                                    Button(action: {
                                                            presentingSheet = .addByManually
                                                            isSheetPresented = true
                                                    }) {
                                                            Label("Enter Manually", systemImage: "text.cursor")
                                                    }
                                            } label: {
                                                    Image(systemName: "plus")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 25)
                                                            .padding(.leading, 8)
                                                            .contentShape(Rectangle())
                                            }
                                    }
                            }
                    }
                    .sheet(isPresented: $isPresentedSetting) {
                        Text("Setting")
                    }
                    .sheet(isPresented: $isSheetPresented) {
                            switch presentingSheet {
                            case .moreExport:
                                    ExportView(isPresented: $isSheetPresented, tokens: tokensToExport)
                            case .moreAbout:
                                    AboutView(isPresented: $isSheetPresented)
                            case .addByScanning:
                                    Scanner(isPresented: $isSheetPresented, codeTypes: [.qr], completion: handleScanning(result:))
                            case .addByQRCodeImage:
                                    PhotoPicker(completion: handlePickedImage(uri:))
                            case .addByManually:
                                    ManualEntryView(isPresented: $isSheetPresented, completion: addItem(_:))
                            case .cardDetailView:
                                    TokenDetailView(isPresented: $isSheetPresented, token: token(of: fetchedTokens[tokenIndex]))
                            case .cardEditing:
                                    EditAccountView(isPresented: $isSheetPresented, token: token(of: fetchedTokens[tokenIndex]), tokenIndex: tokenIndex) { index, issuer, account in
                                            handleAccountEditing(index: index, issuer: issuer, account: account)
                                    }
                            default:
                                EmptyView()
                            }
                    }
                    .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.text, .image], allowsMultipleSelection: false) { result in
                            switch result {
                            case .failure(let error):
                                    print(".fileImporter() failure: \(error.localizedDescription)")
                            case .success(let urls):
                                    guard let pickedUrl: URL = urls.first else { return }
                                    guard pickedUrl.startAccessingSecurityScopedResource() else { return }
                                    let cachePathComponent = Date.currentDateText + pickedUrl.lastPathComponent
                                    let cacheUrl: URL = .tmpDirectoryUrl.appendingPathComponent(cachePathComponent)
                                    try? FileManager.default.copyItem(at: pickedUrl, to: cacheUrl)
                                    pickedUrl.stopAccessingSecurityScopedResource()
                                    handlePickedFile(url: cacheUrl)
                            }
                    }
                }
                .navigationViewStyle(.stack)
        }
    
    @ViewBuilder
    var mainView: some View {
        if fetchedTokens.isEmpty {
            emptyView
        } else {
            listView
        }
    }
    
    var emptyView: some View {
        VStack {
            // home-empty
            Image("home-empty")
                .resizable()
                .scaledToFit()
                .frame(width: 250.minScaled, height: 250.minScaled)
                .padding(.leading, 40.minScaled)
            
            // title
            Text("Get Started")
                .font(.system(size: 24, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.blackHeader)
                .padding(.vertical, 4)
            // description
            Text("Add an extra layer of security to your accounts by enabling two-factor authentication.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray149)
                .multilineTextAlignment(.center)
                .frame(width: 300)
            Spacer()
            
        }
        .frame(width: UIScreen.width)
        .padding(.top, 60.minScaled)
    }
    
    var listView: some View {
        List(selection: $selectedTokens) {
            // title
            Text("Authenticator")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            
                ForEach(0..<fetchedTokens.count, id: \.self) { index in
                        let item = fetchedTokens[index]
                                CodeCardView(token: token(of: item), totp: $codes[index], timeRemaining: $timeRemaining)
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = codes[index]
                                                }) {
                                                        Label("Copy Code", systemImage: "doc.on.doc")
                                                }
                                                Button(action: {
                                                        tokenIndex = index
                                                        presentingSheet = .cardDetailView
                                                        isSheetPresented = true
                                                }) {
                                                        Label("View Detail", systemImage: "text.justifyleft")
                                                }
                                                Button(action: {
                                                        tokenIndex = index
                                                        presentingSheet = .cardEditing
                                                        isSheetPresented = true
                                                }) {
                                                        Label("Edit Account", systemImage: "square.and.pencil")
                                                }
                                                Button(role: .destructive) {
                                                        tokenIndex = index
                                                        selectedTokens.removeAll()
                                                        indexSetOnDelete.removeAll()
                                                        isDeletionAlertPresented = true
                                                } label: {
                                                        Label("Delete", systemImage: "trash")
                                                }
                                        }
                }
//                                .onMove(perform: move(from:to:))
                .onDelete(perform: deleteItems)
//                .listRowInsets(EdgeInsets())
//                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .searchable(text: query)
        .animation(.default, value: animationTrigger)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                generateCodes()
                clearTemporaryDirectory()
        }
        .onReceive(timer) { _ in
                timeRemaining = 30 - (Int(Date().timeIntervalSince1970) % 30)
                if timeRemaining == 30 || codes.first == String.zeros {
                        generateCodes()
                }
        }
        .alert(isPresented: $isDeletionAlertPresented) {
                deletionAlert
        }
        .environment(\.editMode, $editMode)
    }
        
        
        // MARK: - Modification
        
        private func addItem(_ token: Token) {
                let newTokenData = TokenData(context: viewContext)
                newTokenData.id = token.id
                newTokenData.uri = token.uri
                newTokenData.displayIssuer = token.displayIssuer
                newTokenData.displayAccountName = token.displayAccountName
                let lastIndexNumber: Int64 = fetchedTokens.last?.indexNumber ?? Int64(fetchedTokens.count)
                newTokenData.indexNumber = lastIndexNumber + 1
                do {
                        try viewContext.save()
                } catch {
                        let nsError = error as NSError
                        print("\(nsError)")
                }
                generateCodes()
        }
//        private func move(from source: IndexSet, to destination: Int) {
//                var idArray: [String] = fetchedTokens.map({ $0.id ?? Token().id })
//                idArray.move(fromOffsets: source, toOffset: destination)
//                for number in 0..<fetchedTokens.count {
//                        let item = fetchedTokens[number]
//                        if let index = idArray.firstIndex(where: { $0 == item.id }) {
//                                if Int64(index) != item.indexNumber {
//                                        fetchedTokens[number].indexNumber = Int64(index)
//                                }
//                        }
//                }
//                do {
//                        try viewContext.save()
//                } catch {
//                        let nsError = error as NSError
//                        print("Unresolved error \(nsError), \(nsError.userInfo)")
//                }
//        }
        private func deleteItems(offsets: IndexSet) {
                selectedTokens.removeAll()
                indexSetOnDelete = offsets
                isDeletionAlertPresented = true
        }
        private func cancelDeletion() {
                indexSetOnDelete.removeAll()
                selectedTokens.removeAll()
                isDeletionAlertPresented = false
        }
        private func performDeletion() {
                if !selectedTokens.isEmpty {
                        _ = selectedTokens.map { oneSelection in
                                _ = fetchedTokens.filter({ $0.id == oneSelection.id }).map(viewContext.delete)
                        }
                } else if !indexSetOnDelete.isEmpty {
                        _ = indexSetOnDelete.map({ fetchedTokens[$0] }).map(viewContext.delete)
                } else {
                        viewContext.delete(fetchedTokens[tokenIndex])
                }
                do {
                        try viewContext.save()
                } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                indexSetOnDelete.removeAll()
                selectedTokens.removeAll()
                isDeletionAlertPresented = false
                generateCodes()
        }
        private var deletionAlert: Alert {
                return Alert(title: Text("Delete Account?"),
                             message: Text("Account Deletion Warning"),
                             primaryButton: .cancel(cancelDeletion),
                             secondaryButton: .destructive(Text("Delete"), action: performDeletion))
        }
        
        // MARK: - Account Adding
        
        private func handleScanning(result: Result<String, ScannerView.ScanError>) {
                isSheetPresented = false
                switch result {
                case .success(let code):
                        let uri: String = code.trimmed()
                        guard !uri.isEmpty else { return }
                        guard let newToken: Token = Token(uri: uri) else { return }
                        addItem(newToken)
                case .failure(let error):
                        print("\(error.localizedDescription)")
                }
        }
        private func handlePickedImage(uri: String) {
                let qrCodeUri: String = uri.trimmed()
                guard !qrCodeUri.isEmpty else { return }
                guard let newToken: Token = Token(uri: qrCodeUri) else { return }
                addItem(newToken)
        }
        private func handlePickedFile(url: URL) {
                guard let content: String = url.readText() else { return }
                let lines: [String] = content.components(separatedBy: .newlines)
                _ = lines.map {
                        if let newToken: Token = Token(uri: $0.trimmed()) {
                                addItem(newToken)
                        }
                }
        }
        
        
        // MARK: - Methods
        
        private func token(of tokenData: TokenData) -> Token {
                guard let id: String = tokenData.id,
                      let uri: String = tokenData.uri,
                      let displayIssuer: String = tokenData.displayIssuer,
                      let displayAccountName: String = tokenData.displayAccountName
                else { return Token() }
                guard let token = Token(id: id, uri: uri, displayIssuer: displayIssuer, displayAccountName: displayAccountName) else { return Token() }
                return token
        }
        private func generateCodes() {
                let placeholder: [String] = Array(repeating: String.zeros, count: 30)
                guard !fetchedTokens.isEmpty else {
                        codes = placeholder
                        return
                }
                let generated: [String] = fetchedTokens.map { code(of: $0) }
                codes = generated + placeholder
                animationTrigger.toggle()
        }
        private func code(of tokenData: TokenData) -> String {
                guard let uri: String = tokenData.uri else { return String.zeros }
                guard let token: Token = Token(uri: uri) else { return String.zeros }
                guard let code: String = OTPGenerator.totp(secret: token.secret, algorithm: token.algorithm, digits: token.digits, period: token.period) else { return String.zeros }
                return code
        }
        
        private func handleAccountEditing(index: Int, issuer: String, account: String) {
                let item: TokenData = fetchedTokens[index]
                if item.displayIssuer != issuer {
                        fetchedTokens[index].displayIssuer = issuer
                }
                if item.displayAccountName != account {
                        fetchedTokens[index].displayAccountName = account
                }
                do {
                        try viewContext.save()
                } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                isSheetPresented = false
        }
        
        private var tokensToExport: [Token] {
                return fetchedTokens.map({ token(of: $0) })
        }
        
        private func clearTemporaryDirectory() {
                guard let urls: [URL] = try? FileManager.default.contentsOfDirectory(at: .tmpDirectoryUrl, includingPropertiesForKeys: nil) else { return }
                _ = urls.map { try? FileManager.default.removeItem(at: $0) }
        }
}

private extension HomeView {
    var floatingButton: some View {
        HomeFloatingButton { selectedOption in
            switch selectedOption {
            case .addByScanning:
                presentingSheet = .addByScanning
                isSheetPresented = true
            case .addByQRCodeImage:
                presentingSheet = .addByQRCodeImage
                isSheetPresented = true
            case .addByManually:
                presentingSheet = .addByManually
                isSheetPresented = true
            case .addByFile:
                isFileImporterPresented = true
            default:
                break
            }
        }
    }
    
}

enum HomeActionE {
        case moreExport
        case moreAbout
        case addByScanning
        case addByQRCodeImage
    case addByFile
        case addByManually
        case cardDetailView
        case cardEditing
}
