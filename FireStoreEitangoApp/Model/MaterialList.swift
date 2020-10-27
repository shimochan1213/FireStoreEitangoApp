
//  TestMaterialList.swift
//  GifPractice2
//
//  Created by 下川勇輝 on 2020/05/19.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import Foundation

class MaterialList{
    
    //英単語を格納する
    
    var list = [MaterialModel]()
    var TOEIC600NounList = [MaterialModel]()

    
    init(){
        
        //correctOrNotについて。正解はすべてtrueであることを前提に作っているのでこの配列では全てtrueでOK
        
        //TOEIC600NounList
        
//        TOEIC600NounList.append(MaterialModel(wordsName: "resume", japanWordsName: "履歴書", correctOrNot: true))
//        TOEIC600NounList.append(MaterialModel(wordsName: "memorandom", japanWordsName: "メモ", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "destination", japanWordsName: "目的地", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "complex", japanWordsName: "(ショッピングモールなど)複合施設", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "equipment", japanWordsName: "設備", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "advertisement", japanWordsName: "広告", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "deadline", japanWordsName: "締切", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "resident", japanWordsName: "住人", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "departure", japanWordsName: "出発", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "preparation", japanWordsName: "(プレゼンなどの)準備", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "option", japanWordsName: "選択肢", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "vehicle", japanWordsName: "乗り物", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "detail", japanWordsName: "詳細", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "council", japanWordsName: "会議、議会", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "organization", japanWordsName: "組織", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "fee", japanWordsName: "料金", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "survey", japanWordsName: "調査", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "packaging", japanWordsName: "梱包", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "delivery", japanWordsName: "配達", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "branch", japanWordsName: "枝、支店", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "brochure", japanWordsName: "パンフレット冊子", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "flyer", japanWordsName: "チラシ", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "crop", japanWordsName: "作物", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "fuel", japanWordsName: "燃料", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "landscaping", japanWordsName: "造園", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "component", japanWordsName: "部品", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "income", japanWordsName: "収入", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "regulation", japanWordsName: "ルール、制約", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "exhibition", japanWordsName: "展示", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "warehouse", japanWordsName: "倉庫", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "district", japanWordsName: "地区", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "duty", japanWordsName: "義務", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "occasion", japanWordsName: "機会", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "opportunity", japanWordsName: "機会", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "function", japanWordsName: "機能", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "institution", japanWordsName: "機関", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "equipment", japanWordsName: "機器、設備", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "conference", japanWordsName: "会議", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "firm", japanWordsName: "会社", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "job opening", japanWordsName: "仕事の空き(役職の空席）", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "management", japanWordsName: "管理、経営", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "candidate", japanWordsName: "候補者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "executive", japanWordsName: "(企業の)重役", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "personnel", japanWordsName: "人事、職員", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "basis", japanWordsName: "基準", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "crew", japanWordsName: "（職場での）チーム", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "atmosphere", japanWordsName: "雰囲気", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "reference", japanWordsName: "前職での実績（転職面接時に確認）", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "department", japanWordsName: "(部署など)部門", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "client", japanWordsName: "顧客、お客様", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "employee", japanWordsName: "従業員", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "stock-holder", japanWordsName: "株主", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "headquarters", japanWordsName: "本社", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "cafeteria", japanWordsName: "社員食堂", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "promotion", japanWordsName: "昇進", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "suggestion", japanWordsName: "提案", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "policy", japanWordsName: "方針", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "expense", japanWordsName: "費用", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "membership", japanWordsName: "会員（サブスクなど）", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "estimate", japanWordsName: "見積もり", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "balance", japanWordsName: "（請求書の）未払い額", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "contract", japanWordsName: "契約", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "payment", japanWordsName: "支払い", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "path", japanWordsName: "小道", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "budget", japanWordsName: "予算", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "quarter", japanWordsName: "四半期(3ヶ月間)", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "bill", japanWordsName: "請求書", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "document", japanWordsName: "書類", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "ability", japanWordsName: "能力", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "reward", japanWordsName: "報酬", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "profit", japanWordsName: "利益", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "benefit", japanWordsName: "福利厚生", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "proposal", japanWordsName: "提案", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "popularity", japanWordsName: "人気", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "labour", japanWordsName: "労働", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "capacity", japanWordsName: "収容能力(部屋など)", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "concern", japanWordsName: "心配", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "background", japanWordsName: "背景", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "research", japanWordsName: "調査", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "recommendation", japanWordsName: "推薦", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "invitation", japanWordsName: "招待", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "reputation", japanWordsName: "評判", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "applicant", japanWordsName: "志願者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "application", japanWordsName: "応募用紙", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "process", japanWordsName: "過程", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "region", japanWordsName: "地域", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "method", japanWordsName: "方法", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "transportation", japanWordsName: "交通手段", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "shuttle", japanWordsName: "（バスなど）送迎便", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "arrival", japanWordsName: "到着", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "result", japanWordsName: "結果", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "agreement", japanWordsName: "同意", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "tips", japanWordsName: "コツ", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "saving", japanWordsName: "節約", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "display", japanWordsName: "展示", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "exhibit", japanWordsName: "展示", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "instruction", japanWordsName: "指示", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "industory", japanWordsName: "産業", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "production", japanWordsName: "生産、製造", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "manufacture", japanWordsName: "メーカー、製造者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "agency", japanWordsName: "（広告や旅行の）代理店", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "editor", japanWordsName: "編集者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "host", japanWordsName: "主催者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "author", japanWordsName: "著者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "mayor", japanWordsName: "市長", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "decade", japanWordsName: "10年", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "anniversary", japanWordsName: "記念日", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "celebration", japanWordsName: "祝賀、祝うこと", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "trade", japanWordsName: "商売", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "profit", japanWordsName: "利益", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "automobile", japanWordsName: "自動車", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "merchandise", japanWordsName: "商品", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "facility", japanWordsName: "施設", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "construction", japanWordsName: "建設", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "clothing", japanWordsName: "衣服", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "award", japanWordsName: "賞", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "representative", japanWordsName: "代表者", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "individual", japanWordsName: "個人", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "environment", japanWordsName: "環境", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "neighborhood", japanWordsName: "近所", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "reputation", japanWordsName: "評判", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "complaint", japanWordsName: "不満", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "strength", japanWordsName: "強さ", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "contrast", japanWordsName: "対比", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "cooperation", japanWordsName: "協力", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "claim", japanWordsName: "主張", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "response", japanWordsName: "反応", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "warranty", japanWordsName: "保証書", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "insurance premium", japanWordsName: "保険料", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "deposit", japanWordsName: "保証金", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "donation", japanWordsName: "寄付", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "refund", japanWordsName: "返金", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "priority", japanWordsName: "優先", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "luggage", japanWordsName: "手荷物", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "procedure", japanWordsName: "手続き", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "permission", japanWordsName: "許可", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "proof", japanWordsName: "証拠", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "factor", japanWordsName: "要因", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "connection", japanWordsName: "接続", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "comparison", japanWordsName: "比較", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "findings", japanWordsName: "発見", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "impact", japanWordsName: "影響", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "content", japanWordsName: "中身", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "aspect", japanWordsName: "側面", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "figure", japanWordsName: "グラフ、図", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "range", japanWordsName: "範囲", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "import", japanWordsName: "輸入", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "resource", japanWordsName: "資源", correctOrNot: true))
        TOEIC600NounList.append(MaterialModel(wordsName: "discount", japanWordsName: "割引", correctOrNot: true))
        
        TOEIC600NounList.append(MaterialModel(wordsName: "admission", japanWordsName: "入場", correctOrNot: true))
        
        
        
        
    }
    
    
}

