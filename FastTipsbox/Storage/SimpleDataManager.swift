import Foundation
import SwiftUI

class SimpleDataManager: ObservableObject {
    @Published var tips: [TipItem] = []
    @Published var categories: [CategoryItem] = []
    
    private let tipsKey = "TipBox_Tips"
    private let categoriesKey = "TipBox_Categories"
    
    init() {
        print("🚀 SimpleDataManager: Initializing...")
        
        // Load existing data first
        loadData()
        
        // If no data exists, create default data
        if tips.isEmpty || categories.isEmpty {
            print("📱 SimpleDataManager: No data found, creating default data...")
            createDefaultCategories()
            createDefaultTips()
        }
        
        print("📊 SimpleDataManager: Initialization complete - \(tips.count) tips, \(categories.count) categories")
    }
    
    func loadData() {
        print("📱 SimpleDataManager: Loading data from UserDefaults...")
        
        if let tipsData = UserDefaults.standard.data(forKey: tipsKey),
           let decodedTips = try? JSONDecoder().decode([TipItem].self, from: tipsData) {
            tips = decodedTips
            print("📱 SimpleDataManager: Loaded \(tips.count) tips from UserDefaults")
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([CategoryItem].self, from: categoriesData) {
            categories = decodedCategories
            print("📱 SimpleDataManager: Loaded \(categories.count) categories from UserDefaults")
        }
        
        if categories.isEmpty {
            print("📱 SimpleDataManager: No categories found, creating default data...")
            createDefaultCategories()
        }
        
        if tips.isEmpty {
            print("📱 SimpleDataManager: No tips found, creating default data...")
            createDefaultTips()
        }
        
        print("🔄 SimpleDataManager: Data loading complete - \(tips.count) tips, \(categories.count) categories")
    }
    
    private func createDefaultCategories() {
        print("📁 SimpleDataManager: Creating default categories...")
        
        let defaultCategories = [
            ("Cooking", "fork.knife", "#F4C430"),
            ("Cleaning", "sparkles", "#F4C430"),
            ("Organization", "folder", "#F4C430"),
            ("Health", "heart", "#F4C430"),
            ("Money", "dollarsign.circle", "#F4C430")
        ]
        
        for (name, icon, color) in defaultCategories {
            let category = CategoryItem(name: name, icon: icon, color: color)
            categories.append(category)
            print("📁 SimpleDataManager: Created category '\(name)' with ID \(category.id)")
        }
        
        print("📁 SimpleDataManager: Created \(categories.count) default categories")
        saveData()
    }
    
    private func createDefaultTips() {
        print("📝 SimpleDataManager: Creating 100 default tips...")
        
        // FORCE CREATE CATEGORIES IF EMPTY
        if categories.isEmpty {
            print("❌ SimpleDataManager: No categories available for tips, creating them first...")
            createDefaultCategories()
        }
        
        // CREATE CATEGORIES IF STILL EMPTY
        if categories.isEmpty {
            print("❌ SimpleDataManager: Still no categories, creating them manually...")
            let defaultCategories = [
                ("Cooking", "fork.knife", "#F4C430"),
                ("Cleaning", "sparkles", "#F4C430"),
                ("Organization", "folder", "#F4C430"),
                ("Health", "heart", "#F4C430"),
                ("Money", "dollarsign.circle", "#F4C430")
            ]
            
            for (name, icon, color) in defaultCategories {
                let category = CategoryItem(name: name, icon: icon, color: color)
                categories.append(category)
                print("📁 SimpleDataManager: Created category '\(name)' with ID \(category.id)")
            }
        }
        
        let cookingCategory = categories.first { $0.name == "Cooking" }!
        let cleaningCategory = categories.first { $0.name == "Cleaning" }!
        let organizationCategory = categories.first { $0.name == "Organization" }!
        let healthCategory = categories.first { $0.name == "Health" }!
        let moneyCategory = categories.first { $0.name == "Money" }!
        
        createCookingTips(categoryId: cookingCategory.id)
        createCleaningTips(categoryId: cleaningCategory.id)
        createOrganizationTips(categoryId: organizationCategory.id)
        createHealthTips(categoryId: healthCategory.id)
        createMoneyTips(categoryId: moneyCategory.id)
        
        print("📝 SimpleDataManager: Created \(tips.count) default tips")
        saveData()
    }
    
    private func createCookingTips(categoryId: UUID) {
        let cookingTips = [
            ("Perfect Pasta Water", "Add salt to water only after it boils - this prevents pitting in your pot and ensures even distribution.", "pasta, cooking, basics"),
            ("Knife Sharpening", "Sharpen your knives regularly with a honing steel before each use for cleaner cuts and safer cooking.", "knives, sharpening, safety"),
            ("Room Temperature Eggs", "Let eggs come to room temperature before baking for better texture and even cooking.", "baking, eggs, temperature"),
            ("Herb Storage", "Store fresh herbs in a glass of water in the fridge, covered with a plastic bag, to keep them fresh longer.", "herbs, storage, freshness"),
            ("Onion Tears", "Chill onions in the fridge for 30 minutes before cutting to reduce tears and make slicing easier.", "onions, cutting, tears"),
            ("Garlic Peeling", "Soak garlic cloves in warm water for 10 minutes to make peeling much easier.", "garlic, peeling, preparation"),
            ("Rice Cooking", "Let rice rest for 5 minutes after cooking before fluffing with a fork for perfect texture.", "rice, cooking, texture"),
            ("Avocado Ripening", "Place unripe avocados in a paper bag with a banana to speed up ripening process.", "avocado, ripening, fruit"),
            ("Bread Storage", "Store bread in a cool, dry place or freeze slices individually for longer freshness.", "bread, storage, freshness"),
            ("Spice Freshness", "Buy whole spices and grind them as needed for maximum flavor and aroma.", "spices, grinding, flavor"),
            ("Meat Resting", "Let cooked meat rest for 5-10 minutes before slicing to retain juices and improve tenderness.", "meat, resting, juiciness"),
            ("Vegetable Blanching", "Blanch vegetables in ice water after boiling to stop cooking and preserve color.", "vegetables, blanching, color"),
            ("Cheese Grating", "Freeze cheese for 15 minutes before grating to prevent it from sticking to the grater.", "cheese, grating, preparation"),
            ("Tomato Peeling", "Score tomatoes with an X and blanch in boiling water for 30 seconds to easily remove skin.", "tomatoes, peeling, preparation"),
            ("Egg Separation", "Use your hands instead of shells to separate eggs - it's cleaner and less likely to break yolks.", "eggs, separation, technique"),
            ("Pancake Fluffiness", "Don't overmix pancake batter - lumps are okay and will create fluffier pancakes.", "pancakes, mixing, texture"),
            ("Chocolate Melting", "Melt chocolate in a double boiler or microwave in 30-second intervals to prevent burning.", "chocolate, melting, technique"),
            ("Salad Dressing", "Make salad dressing in a jar and shake vigorously for perfect emulsification.", "salad, dressing, emulsification"),
            ("Potato Storage", "Store potatoes in a cool, dark place away from onions to prevent sprouting.", "potatoes, storage, sprouting"),
            ("Cake Testing", "Insert a toothpick into the center of cakes - it should come out clean when fully baked.", "cakes, testing, doneness")
        ]
        
        for (title, content, tags) in cookingTips {
            let tip = TipItem(title: title, content: content, categoryId: categoryId, tags: tags)
            tips.append(tip)
        }
    }
    
    private func createCleaningTips(categoryId: UUID) {
        let cleaningTips = [
            ("Microfiber Magic", "Use microfiber cloths for dusting - they trap dust instead of just moving it around.", "microfiber, dusting, efficiency"),
            ("Vinegar Cleaner", "Mix equal parts white vinegar and water for an effective, natural all-purpose cleaner.", "vinegar, natural, cleaner"),
            ("Baking Soda Scrub", "Use baking soda as a gentle abrasive for tough stains on surfaces and cookware.", "baking soda, scrubbing, stains"),
            ("Lemon Fresh", "Cut a lemon in half and use it to clean cutting boards and remove odors naturally.", "lemon, cutting boards, odors"),
            ("Toothbrush Detail", "Use old toothbrushes for cleaning grout, corners, and other hard-to-reach areas.", "toothbrush, grout, corners"),
            ("Dryer Sheet Dust", "Use dryer sheets to dust baseboards and blinds - they repel dust for longer.", "dryer sheets, dusting, repelling"),
            ("Coffee Grounds", "Use used coffee grounds to scrub greasy pans and remove stubborn food residue.", "coffee grounds, scrubbing, grease"),
            ("Newspaper Windows", "Clean windows with newspaper instead of paper towels for a streak-free shine.", "newspaper, windows, streak-free"),
            ("Salt Stain Removal", "Mix salt with lemon juice to remove rust stains from bathroom fixtures.", "salt, lemon, rust stains"),
            ("Olive Oil Polish", "Use a small amount of olive oil to polish stainless steel appliances and fixtures.", "olive oil, stainless steel, polish"),
            ("Cornstarch Carpet", "Sprinkle cornstarch on carpet stains, let sit, then vacuum for natural stain removal.", "cornstarch, carpet, stains"),
            ("Hair Dryer Stickers", "Use a hair dryer to heat up stubborn stickers and make them easier to remove.", "hair dryer, stickers, removal"),
            ("Aluminum Foil Scrub", "Crumple aluminum foil to scrub baked-on food from pans and baking sheets.", "aluminum foil, scrubbing, baked-on"),
            ("White Eraser Marks", "Use white erasers to remove scuff marks from walls and painted surfaces.", "white eraser, scuff marks, walls"),
            ("Dish Soap Degreaser", "Use dish soap to cut through grease on stovetops and range hoods effectively.", "dish soap, grease, stovetop"),
            ("Ice Cube Gum", "Freeze gum with ice cubes to make it brittle and easy to scrape off surfaces.", "ice cubes, gum, removal"),
            ("Ketchup Copper", "Use ketchup to clean copper pots and pans - the acid removes tarnish naturally.", "ketchup, copper, tarnish"),
            ("Mayonnaise Stickers", "Apply mayonnaise to sticker residue and let sit before wiping clean.", "mayonnaise, stickers, residue"),
            ("Club Soda Spills", "Blot fresh spills with club soda to prevent staining on carpets and upholstery.", "club soda, spills, staining"),
            ("Dryer Lint Fire", "Save dryer lint as excellent fire starter for camping or fireplaces.", "dryer lint, fire starter, camping")
        ]
        
        for (title, content, tags) in cleaningTips {
            let tip = TipItem(title: title, content: content, categoryId: categoryId, tags: tags)
            tips.append(tip)
        }
    }
    
    private func createOrganizationTips(categoryId: UUID) {
        let organizationTips = [
            ("One In, One Out", "For every new item you bring home, remove one similar item to maintain organization.", "decluttering, balance, maintenance"),
            ("Vertical Storage", "Use vertical space with shelves, hooks, and hanging organizers to maximize storage.", "vertical, storage, space"),
            ("Label Everything", "Label containers, boxes, and storage areas to make finding items effortless.", "labeling, containers, finding"),
            ("Daily Reset", "Spend 10 minutes each evening putting everything back in its designated place.", "daily, reset, routine"),
            ("Donation Box", "Keep a donation box in a convenient location for items you no longer need.", "donation, decluttering, convenience"),
            ("Digital Declutter", "Organize digital files with clear folder names and delete unnecessary files regularly.", "digital, files, organization"),
            ("Meal Prep Containers", "Use clear, stackable containers for meal prep to save space and see contents easily.", "meal prep, containers, visibility"),
            ("Cable Management", "Use cable ties, clips, and organizers to keep cords neat and tangle-free.", "cables, management, organization"),
            ("Seasonal Rotation", "Store seasonal items in clearly labeled boxes and rotate them as needed.", "seasonal, rotation, storage"),
            ("Entryway Station", "Create a designated spot near the door for keys, bags, and daily essentials.", "entryway, station, essentials"),
            ("Paper System", "Implement a filing system for important papers and go digital when possible.", "papers, filing, digital"),
            ("Closet Organization", "Organize clothes by type and color for easy selection and maintenance.", "closet, clothes, organization"),
            ("Pantry Zones", "Group similar items together in your pantry for efficient meal planning.", "pantry, zones, meal planning"),
            ("Tool Organization", "Keep tools organized by type and frequency of use for easy access.", "tools, organization, access"),
            ("Memory Boxes", "Create memory boxes for sentimental items to keep them organized and accessible.", "memories, boxes, sentimental"),
            ("Digital Photos", "Organize photos by date and event, and delete blurry or duplicate images.", "photos, digital, organization"),
            ("Receipt Management", "Take photos of receipts and store them digitally to reduce paper clutter.", "receipts, digital, photos"),
            ("Gift Wrapping Station", "Create a dedicated area for gift wrapping supplies and tools.", "gift wrapping, station, supplies"),
            ("Cleaning Supplies", "Keep cleaning supplies organized by room or task for efficient cleaning.", "cleaning, supplies, organization"),
            ("Emergency Kit", "Maintain an organized emergency kit with clearly labeled and dated items.", "emergency, kit, preparedness")
        ]
        
        for (title, content, tags) in organizationTips {
            let tip = TipItem(title: title, content: content, categoryId: categoryId, tags: tags)
            tips.append(tip)
        }
    }
    
    private func createHealthTips(categoryId: UUID) {
        let healthTips = [
            ("Morning Hydration", "Drink a glass of water first thing in the morning to kickstart your metabolism.", "hydration, morning, metabolism"),
            ("Posture Check", "Set hourly reminders to check and correct your posture throughout the day.", "posture, reminders, health"),
            ("Deep Breathing", "Practice 4-7-8 breathing: inhale for 4, hold for 7, exhale for 8 seconds.", "breathing, relaxation, technique"),
            ("Sleep Schedule", "Go to bed and wake up at the same time every day, even on weekends.", "sleep, schedule, consistency"),
            ("Blue Light Filter", "Use blue light filters on devices 2 hours before bedtime for better sleep.", "blue light, sleep, devices"),
            ("Stretching Routine", "Do 5 minutes of stretching every morning to improve flexibility and circulation.", "stretching, morning, flexibility"),
            ("Hand Washing", "Wash hands for at least 20 seconds with soap and warm water regularly.", "hand washing, hygiene, prevention"),
            ("Eye Rest", "Follow the 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds.", "eyes, rest, screen time"),
            ("Healthy Snacking", "Keep healthy snacks like nuts and fruits within reach to avoid unhealthy choices.", "snacking, healthy, preparation"),
            ("Stress Management", "Practice meditation or mindfulness for 10 minutes daily to reduce stress.", "stress, meditation, mindfulness"),
            ("Vitamin D", "Get 15-30 minutes of sunlight daily or consider vitamin D supplements.", "vitamin D, sunlight, supplements"),
            ("Meal Timing", "Eat meals at regular intervals to maintain stable blood sugar levels.", "meal timing, blood sugar, stability"),
            ("Hydration Tracking", "Drink half your body weight in ounces of water daily for optimal hydration.", "hydration, tracking, calculation"),
            ("Exercise Variety", "Mix cardio, strength training, and flexibility exercises for balanced fitness.", "exercise, variety, balance"),
            ("Mental Health", "Practice gratitude by writing down 3 things you're thankful for each day.", "gratitude, mental health, journaling"),
            ("Screen Breaks", "Take a 5-minute break from screens every hour to reduce eye strain.", "screen breaks, eye strain, rest"),
            ("Sleep Environment", "Keep your bedroom cool, dark, and quiet for optimal sleep quality.", "sleep, environment, quality"),
            ("Social Connection", "Maintain regular social connections for mental and emotional well-being.", "social, connection, well-being"),
            ("Preventive Care", "Schedule regular check-ups and screenings for early detection of health issues.", "preventive, care, screenings"),
            ("Mindful Eating", "Eat slowly and without distractions to improve digestion and satisfaction.", "mindful eating, digestion, satisfaction")
        ]
        
        for (title, content, tags) in healthTips {
            let tip = TipItem(title: title, content: content, categoryId: categoryId, tags: tags)
            tips.append(tip)
        }
    }
    
    private func createMoneyTips(categoryId: UUID) {
        let moneyTips = [
            ("50/30/20 Rule", "Allocate 50% for needs, 30% for wants, and 20% for savings and debt repayment.", "budgeting, allocation, savings"),
            ("Emergency Fund", "Build an emergency fund covering 3-6 months of expenses for financial security.", "emergency fund, security, expenses"),
            ("Automated Savings", "Set up automatic transfers to savings accounts to build wealth effortlessly.", "automated, savings, transfers"),
            ("Track Expenses", "Record every expense for a month to identify spending patterns and opportunities.", "tracking, expenses, patterns"),
            ("Debt Snowball", "Pay minimums on all debts, then put extra money toward the smallest debt first.", "debt, snowball, strategy"),
            ("Price Comparison", "Always compare prices online before making purchases, especially for big-ticket items.", "price comparison, shopping, savings"),
            ("Cash Back Apps", "Use cash back apps and credit cards to earn money on purchases you already make.", "cash back, apps, rewards"),
            ("Meal Planning", "Plan meals weekly and shop with a list to reduce food waste and save money.", "meal planning, shopping, waste"),
            ("Energy Efficiency", "Invest in energy-efficient appliances and LED bulbs to reduce utility bills.", "energy, efficiency, utilities"),
            ("Subscription Audit", "Review and cancel unused subscriptions monthly to eliminate unnecessary expenses.", "subscriptions, audit, expenses"),
            ("Buy Generic", "Choose generic brands for medications, groceries, and household items when possible.", "generic, brands, savings"),
            ("Negotiate Bills", "Call service providers annually to negotiate better rates on insurance and utilities.", "negotiate, bills, rates"),
            ("Invest Early", "Start investing early, even small amounts, to benefit from compound interest.", "investing, early, compound interest"),
            ("Tax Optimization", "Maximize tax-advantaged accounts like 401(k)s and IRAs for long-term wealth building.", "taxes, optimization, retirement"),
            ("Insurance Review", "Review insurance policies annually to ensure adequate coverage at competitive rates.", "insurance, review, coverage"),
            ("Side Hustle", "Develop a side income stream to accelerate debt payoff and savings goals.", "side hustle, income, goals"),
            ("Buy Used", "Consider buying quality used items for cars, furniture, and electronics to save money.", "used, quality, savings"),
            ("DIY Projects", "Learn basic home and car maintenance to reduce service costs over time.", "DIY, maintenance, costs"),
            ("Financial Goals", "Set specific, measurable financial goals with timelines for motivation and tracking.", "goals, financial, tracking"),
            ("Credit Score", "Monitor and improve your credit score for better loan rates and financial opportunities.", "credit score, monitoring, improvement")
        ]
        
        for (title, content, tags) in moneyTips {
            let tip = TipItem(title: title, content: content, categoryId: categoryId, tags: tags)
            tips.append(tip)
        }
    }
    
    private func saveData() {
        if let encodedTips = try? JSONEncoder().encode(tips) {
            UserDefaults.standard.set(encodedTips, forKey: tipsKey)
        }
        if let encodedCategories = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encodedCategories, forKey: categoriesKey)
        }
        print("💾 SimpleDataManager: Data saved to UserDefaults")
    }
    
    func addTip(_ tip: TipItem) {
        tips.append(tip)
        saveData()
    }
    
    func updateTip(_ tip: TipItem) {
        if let index = tips.firstIndex(where: { $0.id == tip.id }) {
            tips[index] = tip
            saveData()
        }
    }
    
    func deleteTip(_ tip: TipItem) {
        tips.removeAll { $0.id == tip.id }
        saveData()
    }
    
    func addCategory(_ category: CategoryItem) {
        categories.append(category)
        saveData()
    }
    
    func updateCategory(_ category: CategoryItem) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveData()
        }
    }
    
    func deleteCategory(_ category: CategoryItem) {
        categories.removeAll { $0.id == category.id }
        tips.removeAll { $0.categoryId == category.id }
        saveData()
    }
    
    func resetData() {
        print("🔄 SimpleDataManager: Resetting all data...")
        tips.removeAll()
        categories.removeAll()
        createDefaultCategories()
        createDefaultTips()
        print("🔄 SimpleDataManager: Data reset complete - \(tips.count) tips, \(categories.count) categories")
    }
}

struct TipItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var categoryId: UUID
    var tags: String
    var favoriteCount: Int
    var createdAt: Date
    
    init(title: String, content: String, categoryId: UUID, tags: String = "") {
        self.id = UUID()
        self.title = title
        self.content = content
        self.categoryId = categoryId
        self.tags = tags
        self.favoriteCount = 0
        self.createdAt = Date()
    }
}

struct CategoryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var color: String
    var isLocked: Bool
    var createdAt: Date
    
    init(name: String, icon: String = "folder", color: String = "#F4C430", isLocked: Bool = false) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.color = color
        self.isLocked = isLocked
        self.createdAt = Date()
    }
}

enum SortOption: String, CaseIterable {
    case newest = "newest"
    case mostUsed = "mostUsed"
    case category = "category"
    
    var displayName: String {
        switch self {
        case .newest: return "Newest"
        case .mostUsed: return "Most Used"
        case .category: return "Category"
        }
    }
    
    var icon: String {
        switch self {
        case .newest: return "clock"
        case .mostUsed: return "heart.fill"
        case .category: return "folder"
        }
    }
}