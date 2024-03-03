* @ValidationCode : MjotMTM4NjM5MDgyNDpDcDEyNTI6MTY2MDcxODQ4NTc3NDpuYXppYjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9TUDkuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Aug 2022 12:41:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.AF.MICR.AUTO.INPUT.RTN
* Description : AUTO INPUT Account, Category, BRANCH CODE, STATUS AND ENTRY DATE
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.CHEQUE.TYPE
    $INSERT  I_F.EB.JBL.MICR.MGT

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING AC.AccountOpening
    $USING CQ.ChqConfig
    
    FN.ACCT  = "F.ACCOUNT"
    F.ACCT   = ''

    FN.CHQ.TYPE='F.CHEQUE.TYPE'
    F.CHQ.TYPE=''
    Y.T24.AC = FIELDS(EB.SystemTables.getIdNew(), "." , 2)

    Y.CHQ.TYPE = FIELDS(EB.SystemTables.getIdNew(), "." , 1)

    !DEBUG
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.CHQ.TYPE, F.CHQ.TYPE)

    EB.DataAccess.FRead(FN.ACCT, Y.T24.AC, ACC.REC, F.ACCT, ERR)
    IF ACC.REC NE '' THEN

        EB.DataAccess.FRead(FN.CHQ.TYPE,Y.CHQ.TYPE,REC.CHQ.REQ,F.CHQ.TYPE,ERR.REQ)

        EB.LocalReferences.GetLocRef('CHEQUE.TYPE','LT.TR.TYPE',Y.TR.TYPE)

        EB.SystemTables.setRNew(EB.JBL82.ACCOUNT, Y.T24.AC)
        EB.SystemTables.setRNew(EB.JBL82.CATEGORY, ACC.REC<AC.AccountOpening.Account.Category>)
        EB.SystemTables.setRNew(EB.JBL82.TR.TYPE, REC.CHQ.REQ<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.TR.TYPE>)
        EB.SystemTables.setRNew(EB.JBL82.CHQ.TYPE, Y.CHQ.TYPE)
        EB.SystemTables.setRNew(EB.JBL82.BRANCH.CODE, ACC.REC<AC.AccountOpening.Account.CoCode>)
        EB.SystemTables.setRNew(EB.JBL82.STATUS, "PENDING")
        EB.SystemTables.setRNew(EB.JBL82.REQUEST.DATE, EB.SystemTables.getToday())

    END
RETURN
