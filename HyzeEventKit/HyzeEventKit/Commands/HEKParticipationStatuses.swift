//
//  HEKParticipationStatuses.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

enum HEKParticipationStatuses: String {
	case needs_action			=	"NEEDS-ACTION"
	case accepted				=	"ACCEPTED"
	case declined				=	"DECLINED"
	case tentative				=	"TENTATIVE"
	case delegated				=	"DELEGATED"
	case completed				=	"COMPLETED"
	case in_process				=	"IN-PROCESS"
}
