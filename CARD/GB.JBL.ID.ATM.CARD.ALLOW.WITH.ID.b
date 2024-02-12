* @ValidationCode : MjotNDY3NTAwNTMwOkNwMTI1MjoxNzA0Nzg5MDkwNTgwOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:31:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
* THIS ROUTINE USE FOR BARANCH PERMISSION AND ID CHECK
* Developed By: Md. Robiul Islam
*Deploy Date: 12 JAN 2017
*Modified Date: 07 FEB 2017
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.ID.ATM.CARD.ALLOW.WITH.ID
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :01/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine checks request status and allow input
*                         based on it either from Branch or from Head Office.
* Subroutine Type: ID Routine
* Attached To    : EB.JBL.ATM.CARD.MGT,DENIED
* Attached As    : ID ROUTINE
* TAFC Routine Name : ATM.CARD.ALLOW.WITH.ID - R09
*-----------------------------------------------------------------------------

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.ID.ATM.CARD.ALLOW.WITH.ID Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput

*******--------------------------TRACER-END--------------------------------------------------------*********************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT GLOBUS.BP I_F.COMPANY
*    $INSERT GLOBUS.BP I_F.COMPANY.SMS.GROUP
    $USING ST.CompanyCreation
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing

    Y.COM = EB.SystemTables.getComi()

    Y.ATM.ID = EB.SystemTables.getComi()
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    FN.AC = "F.ACCOUNT"
    F.AC = ""

    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.TODAY = EB.SystemTables.getToday()

    EB.DataAccess.Opf(FN.ATM, F.ATM)
    EB.DataAccess.Opf(FN.ATM.NAU, F.ATM.NAU)
    EB.DataAccess.Opf(FN.AC, F.AC)
    
    EB.DataAccess.FRead(FN.ATM, Y.ATM.ID, R.ATM.REC, F.ATM, Y.ERR)
    EB.DataAccess.FRead(FN.ATM.NAU, Y.ATM.ID, R.ATM.REC.NAU, F.ATM.NAU, Y.ERR)
    Y.REQUEST = "EB.JBL.ATM.CARD.MGT":Y.PGM.VERSION
    
    IF R.ATM.REC NE "" THEN
        Y.ACCOUNT = R.ATM.REC<EB.ATM19.ACCT.NO>
    END
    ELSE
        Y.ACCOUNT = R.ATM.REC.NAU<EB.ATM19.ACCT.NO>
    END
    
    EB.DataAccess.FRead(FN.AC, Y.ACCOUNT, R.ACT.REC, F.AC, Y.ERR)
    Y.AC.COMPANY = R.ACT.REC<AC.AccountOpening.Account.CoCode>

    IF Y.ID.COMPANY NE "BD0012001" AND (Y.REQUEST  EQ "EB.JBL.ATM.CARD.MGT,UPDATE" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,CLOSEHO" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,DENIED" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,PINHO" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,BATTAG") THEN
* E="CARD PROCESSING ALLOW ONLY HEAD OFFICE"
        EB.SystemTables.setE("CARD PROCESSING ALLOW ONLY HEAD OFFICE")
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.AC.COMPANY NE "" THEN
        IF Y.ID.COMPANY NE Y.AC.COMPANY THEN
            IF Y.REQUEST  EQ "EB.JBL.ATM.CARD.MGT,UPDATE" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEHO" OR Y.REQUEST EQ  "EB.JBL.ATM.CARD.MGT,DENIED" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINHO" OR Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,BATTAG" THEN

            END
            ELSE
* E="CARD INPUT GIVEN ONLY OWN BRANCH"
                EB.SystemTables.setE("CARD INPUT GIVEN ONLY OWN BRANCH")
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END


*****************************************ID check*************************************
    Y.LEN = LEN(Y.COM)
    IF Y.LEN NE 12 THEN
* E="Please Click New Deal for create new request"
        EB.SystemTables.setE("Please Click New Deal for create new request")
        EB.ErrorProcessing.StoreEndError()
    END
    IF LEFT(Y.COM, 2) NE "CA" THEN
* E="Please Click New Deal for create new request"
        EB.SystemTables.setE("Please Click New Deal for create new request")
        EB.ErrorProcessing.StoreEndError()
    END
    FOR I=1 TO Y.LEN
        Y.CHAR = SUBSTRINGS(Y.COM, I, 1)
        IF ISALPHA(Y.CHAR) AND Y.CHAR NE UPCASE(Y.CHAR) THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
            BREAK
        END
    NEXT I

* Y.DATE = Y.TODAY
    CALL JULDATE(Y.DATE,Y.JULD)
    Y.DATE = RIGHT(Y.JULD, 5)
    Y.DATE.COM = SUBSTRINGS(Y.COM, 3, 5)
    
    IF Y.DATE NE Y.DATE.COM AND Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,ISSUE" AND Y.VFUNCTION EQ 'I'  THEN
        IF R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DENIED"  THEN
* E= "Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
    IF ISDIGIT(RIGHT(Y.COM,5)) AND Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,ISSUE" AND Y.VFUNCTION EQ 'I' THEN
* E="Please Click New Deal for create new request"
        EB.SystemTables.setE("Please Click New Deal for create new request")
        EB.ErrorProcessing.StoreEndError()
    END
*******************************************************END ID CHECK*****************************************
****************************************************VERSION check*******************************************

    IF Y.VFUNCTION EQ 'I' THEN
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,ISSUE" AND  R.ATM.REC<EB.ATM19.CARD.STATUS> NE ""  THEN
            IF R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DENIED"  THEN
* E="Please Click New Deal for create new request"
                EB.SystemTables.setE("Please Click New Deal for create new request")
                EB.ErrorProcessing.StoreEndError()
            END
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,REISSUE" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DONE" THEN
            IF R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DENIED"  THEN
* E="Please Click New Deal for create new request"
                EB.SystemTables.setE("Please Click New Deal for create new request")
                EB.ErrorProcessing.StoreEndError()
            END
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINREQ" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DONE" THEN
            IF R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DENIED"  THEN
* E="Please Click New Deal for create new request"
                EB.SystemTables.setE("Please Click New Deal for create new request")
                EB.ErrorProcessing.StoreEndError()
            END
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSE" AND  R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DONE"  THEN
            IF R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DENIED"  THEN
* E="Please Click New Deal for create new request"
                EB.SystemTables.setE("Please Click New Deal for create new request")
                EB.ErrorProcessing.StoreEndError()
            END
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,UPDATE" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "PENDING"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,DENIED" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "PENDING"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEHO" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "PENDING"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,PINHO" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "PENDING"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,DELIVERY" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "APPROVED"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,CLOSEBR" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "APPROVED"  THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.REQUEST EQ "EB.JBL.ATM.CARD.MGT,WAIVE" AND R.ATM.REC<EB.ATM19.CARD.STATUS> NE "DONE" THEN
* E="Please Click New Deal for create new request"
            EB.SystemTables.setE("Please Click New Deal for create new request")
            EB.ErrorProcessing.StoreEndError()
        END
    END

*******************************************************END VERSION CHECK*****************************************
*******************************************************COMPANY ALLOW*********************************************
    FN.SMS = 'F.COMPANY.SMS.GROUP'
    F.SMS = ''
    Y.ID = 'ATM.TRANSACTION.COMPANY.ALLOW'
    
    EB.DataAccess.Opf(FN.SMS, F.SMS)
    EB.DataAccess.FRead(FN.SMS, Y.ID, R.SMS, F.SMS, ERR.SMS)
    Y.COUNT = DCOUNT(R.SMS, @VM)
    Y.FLUG=1
    
    FOR I=1 TO Y.COUNT
* CO.CODE = R.SMS<CO.SMS.COMPANY.CODE,I>
        Y.CO.CODE = R.SMS<ST.CompanyCreation.CompanySmsGroup.CoSmsCompanyCode, I>
        IF Y.ID.COMPANY EQ Y.CO.CODE THEN
            Y.FLUG=0
            BREAK
        END
    NEXT I
    
    IF Y.FLUG THEN
* E="Your Branch are not allow to submit ATM Card request"
        EB.SystemTables.setE("Your Branch are not allow to submit ATM Card request")
        EB.ErrorProcessing.StoreEndError()
    END
************************************************************END COMPANY ALLOW*******************************************
RETURN
END
