*-----------------------------------------------------------------------------
* <Rating>-58</Rating>
*-----------------------------------------------------------------------------
**************************************************
* ROUTINE TO GENERATE REPORT FOR ALL SINGLE BRANCHES
**************************************************
    PROGRAM CUS.SUPP.ML.M2

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.COMPANY


*************READ THIS CAREFULLY BEFORE RUN THIS ROUTINE ***********************
*DEFINE THIS ROUTINE AS MAINLINE ROUTINE
*LOGIN IN CLASSIC MODE "BNK" AND RUN AS MAIN LINE ROUTINE
*"TSM" SHOULD BE AS "START" AND "BNK/OFS.MESSAGE.SERVICE" SHOULD BE "AUTO/START"
*IF "BNK/OFS.MESSAGE.SERVICE" IS COMITTED WITH "START" THEN START SERVICE MANAGER "START.TSM -DEBUG" IN DEBUG MODE AND START SERVICE MANUALLY.
*IF "BNK/OFS.MESSAGE.SERVICE" IS COMITTED WITH "AUTO" THEN SYSTEM BY DEFAULT TAKE CARE OF PROCESSING MESSAGE
*IRRESPECTIVE OF SERVICE MANAGER START WHETHER "DEBUG/PHANTOM" MODE
*USER SHOULD BE SUPER USER
*COMPANY LIST WILL BE TAKEN FROM COMPANY APPLICATION WHICH HAS SINGLE STATUS
*******************************************************************************

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

INIT:

    FN.COMPANY = "F.COMPANY"
    F.COMPANY = ""
    RETURN

OPENFILES:

    CALL OPF(FN.COMPANY,F.COMPANY)
    RETURN

PROCESS:

    SEL.CMD='SELECT ':FN.COMPANY:' WITH LOCAL.REF EQ SINGLE'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    LOOP
        REMOVE COMP.ID FROM SEL.LIST SETTING ID.POS
    WHILE COMP.ID:ID.POS
        CALL LOAD.COMPANY(COMP.ID)
        GOSUB POST.OFS
    REPEAT

    SEL.LIST.5BR = 'BD0010012':FM:'BD0010019':FM:'BD0010343':FM:'BD0010864':FM:'BD0010108':FM:'BD0010759':FM:'BD0010775':FM:'BD0010204':FM:'BD0010278':FM:'BD0010449':FM:'BD0010985':FM:'BD0010275':FM:'BD0010423'
    LOOP
        REMOVE COMP.ID FROM SEL.LIST.5BR SETTING ID.POS
    WHILE COMP.ID:ID.POS
        CALL LOAD.COMPANY(COMP.ID)
        GOSUB POST.OFS.5BR
    REPEAT

    RETURN

POST.OFS:

    Y.SOURCE="BUILD.CONTROL"
    Y.MESSAGE.ALL.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.ALL.CR"
    MSG.ID = ''
    CALL OFS.POST.MESSAGE(Y.MESSAGE.ALL.CR, MSG.ID , Y.SOURCE, "DMUSER")
    CALL JOURNAL.UPDATE ('TEST')

    Y.MESSAGE.ALL.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.ALL.DR"
    MSG.ID = ''
    CALL OFS.POST.MESSAGE(Y.MESSAGE.ALL.DR, MSG.ID , Y.SOURCE, "DMUSER")
    CALL JOURNAL.UPDATE ('TEST')

    Y.FILE.NAME = COMP.ID:'.':TODAY:'.csv'
    Y.DIR = 'CUS.SUPP.DIR/DESTINATION'
    OPEN Y.DIR TO JBASE.DIR ELSE STOP
    READ FILE.VALUES FROM JBASE.DIR,Y.FILE.NAME THEN
        FINDSTR '*U-CD*' IN FILE.VALUES SETTING Y.POS.CD THEN
            IF Y.POS.CD THEN
                FINDSTR '*CREDIT*U-CD*' IN FILE.VALUES SETTING Y.POS.CD.CR THEN
                    IF Y.POS.CD.CR THEN
                        Y.MESSAGE.CD.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-CD.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.CD.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-CD*' IN FILE.VALUES SETTING Y.POS.CD.DR THEN
                    IF Y.POS.CD.DR THEN
                        Y.MESSAGE.CD.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-CD.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.CD.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-SB*' IN FILE.VALUES SETTING Y.POS.SB THEN
            IF Y.POS.SB THEN
                FINDSTR '*CREDIT*U-SB*' IN FILE.VALUES SETTING Y.POS.SB.CR THEN
                    IF Y.POS.SB.CR THEN
                        Y.MESSAGE.SB.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-SB.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.SB.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-SB*' IN FILE.VALUES SETTING Y.POS.SB.DR THEN
                    IF Y.POS.SB.DR THEN
                        Y.MESSAGE.SB.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-SB.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.SB.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-STD*' IN FILE.VALUES SETTING Y.POS.STD THEN
            IF Y.POS.STD THEN
                FINDSTR '*CREDIT*U-STD*' IN FILE.VALUES SETTING Y.POS.STD.CR THEN
                    IF Y.POS.SB.CR THEN
                        Y.MESSAGE.STD.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STD.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STD.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-STD*' IN FILE.VALUES SETTING Y.POS.STD.DR THEN
                    IF Y.POS.STD.DR THEN
                        Y.MESSAGE.STD.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STD.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STD.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END

    END


    RETURN

POST.OFS.5BR:

    Y.SOURCE="BUILD.CONTROL"

    Y.FILE.NAME = COMP.ID:'.':TODAY:'.csv'
    Y.DIR = 'CUS.SUPP.DIR/DESTINATION'
    OPEN Y.DIR TO JBASE.DIR ELSE STOP
    READ FILE.VALUES FROM JBASE.DIR,Y.FILE.NAME THEN
        FINDSTR '*U-TERM*' IN FILE.VALUES SETTING Y.POS.TERM THEN
            IF Y.POS.TERM THEN
                FINDSTR '*CREDIT*U-TERM*' IN FILE.VALUES SETTING Y.POS.TERM.CR THEN
                    IF Y.POS.TERM.CR THEN
                        Y.MESSAGE.TERM.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-TERM.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.TERM.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-TERM*' IN FILE.VALUES SETTING Y.POS.TERM.DR THEN
                    IF Y.POS.TERM.DR THEN
                        Y.MESSAGE.TERM.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-TERM.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.TERM.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-CC*' IN FILE.VALUES SETTING Y.POS.CC THEN
            IF Y.POS.CC THEN
                FINDSTR '*CREDIT*U-CC*' IN FILE.VALUES SETTING Y.POS.CC.CR THEN
                    IF Y.POS.CC.CR THEN
                        Y.MESSAGE.CC.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-CC.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.CC.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-CC*' IN FILE.VALUES SETTING Y.POS.CC.DR THEN
                    IF Y.POS.CC.DR THEN
                        Y.MESSAGE.CC.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-CC.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.CC.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-ECC*' IN FILE.VALUES SETTING Y.POS.ECC THEN
            IF Y.POS.ECC THEN
                FINDSTR '*CREDIT*U-ECC*' IN FILE.VALUES SETTING Y.POS.ECC.CR THEN
                    IF Y.POS.ECC.CR THEN
                        Y.MESSAGE.ECC.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-ECC.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.ECC.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-ECC*' IN FILE.VALUES SETTING Y.POS.ECC.DR THEN
                    IF Y.POS.ECC.DR THEN
                        Y.MESSAGE.ECC.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-ECC.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.ECC.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-OD*' IN FILE.VALUES SETTING Y.POS.OD THEN
            IF Y.POS.OD THEN
                FINDSTR '*CREDIT*U-OD*' IN FILE.VALUES SETTING Y.POS.OD.CR THEN
                    IF Y.POS.OD.CR THEN
                        Y.MESSAGE.OD.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-OD.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.OD.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-OD*' IN FILE.VALUES SETTING Y.POS.OD.DR THEN
                    IF Y.POS.OD.DR THEN
                        Y.MESSAGE.OD.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-OD.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.OD.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-STAG*' IN FILE.VALUES SETTING Y.POS.STAG THEN
            IF Y.POS.STAG THEN
                FINDSTR '*CREDIT*U-STAG*' IN FILE.VALUES SETTING Y.POS.STAG.CR THEN
                    IF Y.POS.STAG.CR THEN
                        Y.MESSAGE.STAG.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STAG.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STAG.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-STAG*' IN FILE.VALUES SETTING Y.POS.STAG.DR THEN
                    IF Y.POS.STAG.DR THEN
                        Y.MESSAGE.STAG.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STAG.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STAG.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-STAFF*' IN FILE.VALUES SETTING Y.POS.STAFF THEN
            IF Y.POS.STAFF THEN
                FINDSTR '*CREDIT*U-STAFF*' IN FILE.VALUES SETTING Y.POS.STAFF.CR THEN
                    IF Y.POS.STAFF.CR THEN
                        Y.MESSAGE.STAFF.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STAFF.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STAFF.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-STAFF*' IN FILE.VALUES SETTING Y.POS.STAFF.DR THEN
                    IF Y.POS.STAFF.DR THEN
                        Y.MESSAGE.STAFF.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-STAFF.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.STAFF.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-RD*' IN FILE.VALUES SETTING Y.POS.RD THEN
            IF Y.POS.RD THEN
                FINDSTR '*CREDIT*U-RD*' IN FILE.VALUES SETTING Y.POS.RD.CR THEN
                    IF Y.POS.RD.CR THEN
                        Y.MESSAGE.RD.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-RD.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.RD.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-RD*' IN FILE.VALUES SETTING Y.POS.RD.DR THEN
                    IF Y.POS.RD.DR THEN
                        Y.MESSAGE.RD.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-RD.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.RD.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-FD*' IN FILE.VALUES SETTING Y.POS.FD THEN
            IF Y.POS.FD THEN
                FINDSTR '*CREDIT*U-FD*' IN FILE.VALUES SETTING Y.POS.FD.CR THEN
                    IF Y.POS.FD.CR THEN
                        Y.MESSAGE.FD.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-FD.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.FD.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-FD*' IN FILE.VALUES SETTING Y.POS.FD.DR THEN
                    IF Y.POS.FD.DR THEN
                        Y.MESSAGE.FD.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-FD.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.FD.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-DEMAND*' IN FILE.VALUES SETTING Y.POS.DL THEN
            IF Y.POS.DL THEN
                FINDSTR '*CREDIT*U-DEMAND*' IN FILE.VALUES SETTING Y.POS.DL.CR THEN
                    IF Y.POS.DL.CR THEN
                        Y.MESSAGE.DL.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-DL.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.DL.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-DEMAND*' IN FILE.VALUES SETTING Y.POS.DL.DR THEN
                    IF Y.POS.DL.DR THEN
                        Y.MESSAGE.DL.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-DL.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.DL.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
        FINDSTR '*U-FCY*' IN FILE.VALUES SETTING Y.POS.FCY THEN
            IF Y.POS.FCY THEN
                FINDSTR '*CREDIT*U-FCY*' IN FILE.VALUES SETTING Y.POS.FCY.CR THEN
                    IF Y.POS.FCY.CR THEN
                        Y.MESSAGE.FCY.CR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-FCY.CR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.FCY.CR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
                FINDSTR '*DEBIT*U-FCY*' IN FILE.VALUES SETTING Y.POS.FCY.DR THEN
                    IF Y.POS.FCY.DR THEN
                        Y.MESSAGE.FCY.DR = "ENQUIRY.REPORT,CUS.SUPP.MODEL2/V/PROCESS,//":COMP.ID:",ER.CUS.SUPP.M2.U-FCY.DR"
                        MSG.ID = ''
                        CALL OFS.POST.MESSAGE(Y.MESSAGE.FCY.DR, MSG.ID , Y.SOURCE, "DMUSER")
                        CALL JOURNAL.UPDATE ('TEST')
                    END
                END
            END
        END
    END
    RETURN

END
